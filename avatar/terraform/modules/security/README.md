# Module: security

Key management, secrets and posture management for a Project Koru deployment.

## What it builds

| Resource | Purpose |
|---|---|
| Key Vault | RBAC only, purge protection, soft delete, public access disabled, private endpoint. Root of trust. |
| Encryption identity | Dedicated user assigned identity that holds key access for customer managed keys. |
| Customer managed key | HSM backed key with an automatic rotation policy. |
| Bootstrap secrets | Platform wiring secrets seeded from other module outputs, never hard coded. |
| Private endpoint | Private connectivity to the vault. |
| Diagnostic settings | Key access audit to Log Analytics. |
| Defender for Cloud plans | Subscription scoped workload protection. |

## Why a dedicated encryption identity

Customer managed keys have a bootstrapping problem: a resource that encrypts
with a system identity does not exist until the identity that needs key access
exists. Using a standalone user assigned identity breaks the cycle. The identity
is created here, granted `Key Vault Crypto Service Encryption User`, and passed
to every module that configures a customer managed key (`cmk_identity_id`,
`cmk_identity_client_id`) alongside the key id (`cmk_key_versionless_id`).

## Controls

| Control | Where |
|---|---|
| KORU-C-11 secrets management | RBAC vault, private endpoint, no shared keys. |
| KORU-C-22 encryption key custody | Customer managed key with rotation. |
| KORU-C-42 destroy protection | `prevent_destroy` on the vault and key. |
| KORU-C-63 threat detection | Defender for Cloud plans. |

Standards: APRA CPS 234 (information security, key management), RBNZ BS11.

## Important inputs

| Variable | Notes |
|---|---|
| `key_vault_admin_object_ids` | Must include the CI deployment identity so Terraform can create the key and secrets. |
| `key_vault_sku` | `premium` in production for HSM backed keys. |
| `bootstrap_secrets` | Sensitive map, values sourced from other modules. |
| `enable_defender` | Subscription scoped. Enable once per subscription. |

## Note on destroy protection

The vault and key carry `prevent_destroy = true`. A `terraform destroy` will be
refused. This is intentional for a regulated deployment. Removing the guard is a
deliberate, reviewed action.
