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
# Azure OpenAI account. Custom subdomain for token based auth, public access
# disabled, local API keys disabled so only Entra ID identities can call it, and
# encrypted with a customer managed key. The Reasoning Plane reaches this only
# over a private endpoint. Controls KORU-C-13 no shared keys, KORU-C-22 CMK,
# KORU-C-30 AI platform isolation. Standard APRA CPS 234, CPG 235.
# ---------------------------------------------------------------------------
resource "azurerm_cognitive_account" "openai" {
  name                               = "${local.name_prefix}-openai-${local.suffix}"
  location                           = var.location
  resource_group_name                = var.resource_group_name
  kind                               = "OpenAI"
  sku_name                           = var.openai_sku
  custom_subdomain_name              = "${local.name_prefix}-openai-${local.suffix}"
  public_network_access_enabled      = false
  local_auth_enabled                 = false
  outbound_network_access_restricted = true

  network_acls {
    default_action = "Deny"
  }

  customer_managed_key {
    key_vault_key_id   = var.cmk_key_versionless_id
    identity_client_id = var.cmk_identity_client_id
  }

  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [var.cmk_identity_id]
  }

  tags = var.tags
}

# Model deployments. One fast conversational model, one stronger reasoning
# model, a small classifier and an embedding model.
resource "azurerm_cognitive_deployment" "this" {
  for_each = var.model_deployments

  name                   = each.value.deployment_name
  cognitive_account_id   = azurerm_cognitive_account.openai.id
  version_upgrade_option = "OnceNewDefaultVersionAvailable"

  model {
    format  = "OpenAI"
    name    = each.value.model_name
    version = each.value.model_version
  }

  sku {
    name     = each.value.sku_name
    capacity = each.value.capacity
  }
}

# ---------------------------------------------------------------------------
# Speech service. Streaming speech to text and real time text to speech for the
# talking avatar. Same isolation posture as the OpenAI account.
# ---------------------------------------------------------------------------
resource "azurerm_cognitive_account" "speech" {
  name                          = "${local.name_prefix}-speech-${local.suffix}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  kind                          = "SpeechServices"
  sku_name                      = var.speech_sku
  custom_subdomain_name         = "${local.name_prefix}-speech-${local.suffix}"
  public_network_access_enabled = false
  local_auth_enabled            = false

  network_acls {
    default_action = "Deny"
  }

  customer_managed_key {
    key_vault_key_id   = var.cmk_key_versionless_id
    identity_client_id = var.cmk_identity_client_id
  }

  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [var.cmk_identity_id]
  }

  tags = var.tags
}

# ---------------------------------------------------------------------------
# Content Safety. Used by the Assurance Plane to screen prompts and responses in
# both directions. The Assurance Plane fails closed, so this is a safety control
# not an optional filter. Control KORU-C-32. Standard responsible AI position.
# ---------------------------------------------------------------------------
resource "azurerm_cognitive_account" "content_safety" {
  name                          = "${local.name_prefix}-safety-${local.suffix}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  kind                          = "ContentSafety"
  sku_name                      = var.content_safety_sku
  custom_subdomain_name         = "${local.name_prefix}-safety-${local.suffix}"
  public_network_access_enabled = false
  local_auth_enabled            = false

  network_acls {
    default_action = "Deny"
  }

  customer_managed_key {
    key_vault_key_id   = var.cmk_key_versionless_id
    identity_client_id = var.cmk_identity_client_id
  }

  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [var.cmk_identity_id]
  }

  tags = var.tags
}

# ---------------------------------------------------------------------------
# Private endpoints.
# ---------------------------------------------------------------------------
module "openai_private_endpoint" {
  source = "../network/modules/private_endpoint"

  name                           = "pe-${local.name_prefix}-openai-${local.suffix}"
  location                       = var.location
  resource_group_name            = var.resource_group_name
  subnet_id                      = var.private_endpoint_subnet_id
  private_connection_resource_id = azurerm_cognitive_account.openai.id
  subresource_names              = ["account"]
  private_dns_zone_ids = [
    var.private_dns_zone_ids["openai"],
    var.private_dns_zone_ids["cognitiveservices"]
  ]
  tags = var.tags
}

module "speech_private_endpoint" {
  source = "../network/modules/private_endpoint"

  name                           = "pe-${local.name_prefix}-speech-${local.suffix}"
  location                       = var.location
  resource_group_name            = var.resource_group_name
  subnet_id                      = var.private_endpoint_subnet_id
  private_connection_resource_id = azurerm_cognitive_account.speech.id
  subresource_names              = ["account"]
  private_dns_zone_ids           = [var.private_dns_zone_ids["cognitiveservices"]]
  tags                           = var.tags
}

module "content_safety_private_endpoint" {
  source = "../network/modules/private_endpoint"

  name                           = "pe-${local.name_prefix}-safety-${local.suffix}"
  location                       = var.location
  resource_group_name            = var.resource_group_name
  subnet_id                      = var.private_endpoint_subnet_id
  private_connection_resource_id = azurerm_cognitive_account.content_safety.id
  subresource_names              = ["account"]
  private_dns_zone_ids           = [var.private_dns_zone_ids["cognitiveservices"]]
  tags                           = var.tags
}

# ---------------------------------------------------------------------------
# Diagnostic settings. Model call audit is required for model risk management
# and for the replayable Ledger story. Control KORU-C-60.
# ---------------------------------------------------------------------------
module "openai_diagnostics" {
  source = "../observability/modules/diagnostics"

  name                       = "diag-${local.name_prefix}-openai-${local.suffix}"
  target_resource_id         = azurerm_cognitive_account.openai.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
}

module "speech_diagnostics" {
  source = "../observability/modules/diagnostics"

  name                       = "diag-${local.name_prefix}-speech-${local.suffix}"
  target_resource_id         = azurerm_cognitive_account.speech.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
}

module "content_safety_diagnostics" {
  source = "../observability/modules/diagnostics"

  name                       = "diag-${local.name_prefix}-safety-${local.suffix}"
  target_resource_id         = azurerm_cognitive_account.content_safety.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
}
