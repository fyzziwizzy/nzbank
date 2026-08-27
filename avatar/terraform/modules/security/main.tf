terraform {
  required_version = ">= 1.9.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

locals {
  name_prefix = "${var.org}-${var.programme}"
  suffix      = "${var.environment}-${var.region_code}-${var.instance}"
}

# ---------------------------------------------------------------------------
# Key Vault. RBAC only, purge protection on, soft delete on, public access off
# and reachable solely over a private endpoint. This is the root of trust for
# customer managed keys and platform secrets. Controls KORU-C-11 secrets
# management and KORU-C-22 encryption key custody. Standards APRA CPS 234 and
# RBNZ BS11.
# ---------------------------------------------------------------------------
resource "azurerm_key_vault" "this" {
  name                          = "${local.name_prefix}-kv-${local.suffix}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  tenant_id                     = var.tenant_id
  sku_name                      = var.key_vault_sku
  enable_rbac_authorization     = true
  purge_protection_enabled      = var.purge_protection_enabled
  soft_delete_retention_days    = var.soft_delete_retention_days
  public_network_access_enabled = false

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  tags = var.tags

  lifecycle {
    # Destroy protection for the root of the key hierarchy. Losing this vault
    # would orphan every customer managed key. Control KORU-C-42.
    prevent_destroy = true
  }
}

# ---------------------------------------------------------------------------
# Dedicated user assigned identity for encryption. Using a UAMI for CMK avoids
# the system identity bootstrapping problem: the identity exists and holds key
# access before any encrypted resource is created. Passed to every module that
# configures a customer managed key.
# ---------------------------------------------------------------------------
resource "azurerm_user_assigned_identity" "cmk" {
  name                = "id-${local.name_prefix}-cmk-${local.suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Deployment identities manage keys and secrets.
resource "azurerm_role_assignment" "kv_admin" {
  for_each = toset(var.key_vault_admin_object_ids)

  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = each.value
}

# The CMK identity may use the key for envelope encryption on behalf of PaaS.
resource "azurerm_role_assignment" "cmk_encrypt_user" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_user_assigned_identity.cmk.principal_id
}

# ---------------------------------------------------------------------------
# Customer managed key with an automatic rotation policy. Bank held keys rather
# than platform managed keys satisfy the key custody obligation. Rotation limits
# the blast radius of any key compromise. Control KORU-C-22.
# ---------------------------------------------------------------------------
resource "azurerm_key_vault_key" "cmk" {
  name         = "cmk-${local.name_prefix}-${local.suffix}"
  key_vault_id = azurerm_key_vault.this.id
  key_type     = var.cmk_key_type
  key_size     = var.cmk_key_size

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey"
  ]

  rotation_policy {
    automatic {
      time_before_expiry = "P30D"
    }
    expire_after         = "P${var.cmk_expiry_days}D"
    notify_before_expiry = "P29D"
  }

  # The key cannot be created until the deployment identity has data plane
  # access to the vault.
  depends_on = [azurerm_role_assignment.kv_admin]

  lifecycle {
    prevent_destroy = true
  }
}

# ---------------------------------------------------------------------------
# Platform wiring secrets. Values are supplied by the caller from other module
# outputs, for example the Application Insights connection string. No secret is
# ever hard coded in the module. Runtime workloads read these by reference using
# their managed identity.
# ---------------------------------------------------------------------------
resource "azurerm_key_vault_secret" "bootstrap" {
  for_each = var.bootstrap_secrets

  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.this.id
  content_type = "text/plain"
  tags         = var.tags

  depends_on = [azurerm_role_assignment.kv_admin]
}

# ---------------------------------------------------------------------------
# Private endpoint for the vault.
# ---------------------------------------------------------------------------
module "kv_private_endpoint" {
  source = "../network/modules/private_endpoint"

  name                           = "pe-${local.name_prefix}-kv-${local.suffix}"
  location                       = var.location
  resource_group_name            = var.resource_group_name
  subnet_id                      = var.private_endpoint_subnet_id
  private_connection_resource_id = azurerm_key_vault.this.id
  subresource_names              = ["vault"]
  private_dns_zone_ids           = [var.private_dns_zone_ids["vault"]]
  tags                           = var.tags
}

# ---------------------------------------------------------------------------
# Diagnostic settings for the vault. Key access is high value audit evidence.
# ---------------------------------------------------------------------------
module "kv_diagnostics" {
  source = "../observability/modules/diagnostics"

  name                       = "diag-${local.name_prefix}-kv-${local.suffix}"
  target_resource_id         = azurerm_key_vault.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
}

# ---------------------------------------------------------------------------
# Microsoft Defender for Cloud plans. Subscription scoped posture management and
# workload protection. Control KORU-C-63 threat detection. Standard APRA
# CPS 234 control testing and detection.
# ---------------------------------------------------------------------------
resource "azurerm_security_center_subscription_pricing" "this" {
  for_each = var.enable_defender ? toset(var.defender_plans) : toset([])

  tier          = "Standard"
  resource_type = each.value
}
