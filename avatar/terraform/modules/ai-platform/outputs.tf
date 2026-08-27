output "openai_account_id" {
  description = "Resource id of the Azure OpenAI account."
  value       = azurerm_cognitive_account.openai.id
}

output "openai_account_name" {
  description = "Name of the Azure OpenAI account."
  value       = azurerm_cognitive_account.openai.name
}

output "openai_endpoint" {
  description = "Endpoint of the Azure OpenAI account."
  value       = azurerm_cognitive_account.openai.endpoint
}

output "openai_identity_principal_id" {
  description = "System assigned principal id of the OpenAI account."
  value       = azurerm_cognitive_account.openai.identity[0].principal_id
}

output "speech_account_id" {
  description = "Resource id of the Speech account."
  value       = azurerm_cognitive_account.speech.id
}

output "speech_endpoint" {
  description = "Endpoint of the Speech account."
  value       = azurerm_cognitive_account.speech.endpoint
}

output "content_safety_id" {
  description = "Resource id of the Content Safety account."
  value       = azurerm_cognitive_account.content_safety.id
}

output "content_safety_endpoint" {
  description = "Endpoint of the Content Safety account."
  value       = azurerm_cognitive_account.content_safety.endpoint
}

output "model_deployment_names" {
  description = "Map of logical role to deployment name."
  value       = { for k, d in azurerm_cognitive_deployment.this : k => d.name }
}
