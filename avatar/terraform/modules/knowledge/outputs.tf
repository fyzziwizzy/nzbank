output "search_service_id" {
  description = "Resource id of the Azure AI Search service."
  value       = azurerm_search_service.this.id
}

output "search_service_name" {
  description = "Name of the Azure AI Search service."
  value       = azurerm_search_service.this.name
}

output "search_identity_principal_id" {
  description = "System assigned principal id of the search service."
  value       = azurerm_search_service.this.identity[0].principal_id
}

output "corpus_storage_account_id" {
  description = "Resource id of the corpus storage account."
  value       = azurerm_storage_account.corpus.id
}

output "corpus_storage_account_name" {
  description = "Name of the corpus storage account."
  value       = azurerm_storage_account.corpus.name
}

output "corpus_container_name" {
  description = "Name of the corpus blob container."
  value       = azurerm_storage_container.corpus.name
}
