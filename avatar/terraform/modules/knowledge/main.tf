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

  # Globally unique, alphanumeric only storage account name. Hyphens dropped per
  # the programme naming convention.
  corpus_storage_name = lower("${var.org}${var.programme}corpus${var.environment}${var.region_code}${var.instance}")
}

# ---------------------------------------------------------------------------
# Azure AI Search. Backs the Knowledge Plane retrieval that grounds every answer
# in product truth. Grounded response only is a conduct control, so retrieval is
# a first class part of the safety story. Semantic ranking improves grounding
# quality. RBAC only, public access disabled, private endpoint. Control
# KORU-C-31 grounding.
# ---------------------------------------------------------------------------
resource "azurerm_search_service" "this" {
  name                          = "${local.name_prefix}-search-${local.suffix}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku                           = var.search_sku
  replica_count                 = var.search_replica_count
  partition_count               = var.search_partition_count
  semantic_search_sku           = var.search_semantic_sku
  public_network_access_enabled = false
  local_authentication_enabled  = false

  # System assigned identity is used by indexers and skillsets to reach the
  # corpus storage account and, where configured, the embedding model.
  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# ---------------------------------------------------------------------------
# Source corpus storage. Holds the product documents that are indexed. Zone
# redundant within the jurisdiction, no shared keys, customer managed key,
# versioning and change feed for lineage and rollback. Control KORU-C-20 data
# lineage, KORU-C-22 CMK.
# ---------------------------------------------------------------------------
resource "azurerm_storage_account" "corpus" {
  name                            = local.corpus_storage_name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  account_tier                    = "Standard"
  account_replication_type        = "ZRS"
  account_kind                    = "StorageV2"
  min_tls_version                 = "TLS1_2"
  public_network_access_enabled   = false
  shared_access_key_enabled       = false
  https_traffic_only_enabled      = true
  allow_nested_items_to_be_public = false

  identity {
    type         = "UserAssigned"
    identity_ids = [var.cmk_identity_id]
  }

  customer_managed_key {
    key_vault_key_id          = var.cmk_key_versionless_id
    user_assigned_identity_id = var.cmk_identity_id
  }

  blob_properties {
    versioning_enabled  = true
    change_feed_enabled = true

    delete_retention_policy {
      days = 30
    }

    container_delete_retention_policy {
      days = 30
    }
  }

  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
  }

  tags = var.tags
}

resource "azurerm_storage_container" "corpus" {
  name                  = "corpus"
  storage_account_id    = azurerm_storage_account.corpus.id
  container_access_type = "private"
}

# ---------------------------------------------------------------------------
# Least privilege data plane access for the search indexer. Read only on the
# corpus. Control KORU-C-12.
# ---------------------------------------------------------------------------
resource "azurerm_role_assignment" "search_corpus_reader" {
  scope                = azurerm_storage_account.corpus.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_search_service.this.identity[0].principal_id
}

# ---------------------------------------------------------------------------
# Private endpoints.
# ---------------------------------------------------------------------------
module "search_private_endpoint" {
  source = "../network/modules/private_endpoint"

  name                           = "pe-${local.name_prefix}-search-${local.suffix}"
  location                       = var.location
  resource_group_name            = var.resource_group_name
  subnet_id                      = var.private_endpoint_subnet_id
  private_connection_resource_id = azurerm_search_service.this.id
  subresource_names              = ["searchService"]
  private_dns_zone_ids           = [var.private_dns_zone_ids["search"]]
  tags                           = var.tags
}

module "corpus_private_endpoint" {
  source = "../network/modules/private_endpoint"

  name                           = "pe-${local.name_prefix}-corpus-${local.suffix}"
  location                       = var.location
  resource_group_name            = var.resource_group_name
  subnet_id                      = var.private_endpoint_subnet_id
  private_connection_resource_id = azurerm_storage_account.corpus.id
  subresource_names              = ["blob"]
  private_dns_zone_ids           = [var.private_dns_zone_ids["blob"]]
  tags                           = var.tags
}

# ---------------------------------------------------------------------------
# Diagnostic settings.
# ---------------------------------------------------------------------------
module "search_diagnostics" {
  source = "../observability/modules/diagnostics"

  name                       = "diag-${local.name_prefix}-search-${local.suffix}"
  target_resource_id         = azurerm_search_service.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
}

module "corpus_diagnostics" {
  source = "../observability/modules/diagnostics"

  name                       = "diag-${local.name_prefix}-corpus-${local.suffix}"
  target_resource_id         = azurerm_storage_account.corpus.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
}
