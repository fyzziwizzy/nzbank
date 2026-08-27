output "key_vault_id" {
  description = "Resource id of the Key Vault."
  value       = azurerm_key_vault.this.id
}

output "key_vault_name" {
  description = "Name of the Key Vault."
  value       = azurerm_key_vault.this.name
}

output "key_vault_uri" {
  description = "Data plane URI of the Key Vault."
  value       = azurerm_key_vault.this.vault_uri
}

output "cmk_key_id" {
  description = "Versioned resource id of the customer managed key."
  value       = azurerm_key_vault_key.cmk.id
}

output "cmk_key_versionless_id" {
  description = "Versionless id of the customer managed key. Preferred for CMK configuration so rotation does not force resource replacement."
  value       = azurerm_key_vault_key.cmk.versionless_id
}

output "cmk_identity_id" {
  description = "Resource id of the encryption user assigned identity."
  value       = azurerm_user_assigned_identity.cmk.id
}

output "cmk_identity_client_id" {
  description = "Client id of the encryption user assigned identity."
  value       = azurerm_user_assigned_identity.cmk.client_id
}

output "cmk_identity_principal_id" {
  description = "Principal id of the encryption user assigned identity."
  value       = azurerm_user_assigned_identity.cmk.principal_id
}

output "bootstrap_secret_ids" {
  description = "Map of secret name to versionless Key Vault secret id for platform wiring secrets."
  value       = { for k, s in azurerm_key_vault_secret.bootstrap : k => s.versionless_id }
}
