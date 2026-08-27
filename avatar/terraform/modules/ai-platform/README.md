# Module: ai-platform

The AI services that power Koru: language models, speech and content safety.

## What it builds

| Resource | Purpose |
|---|---|
| Azure OpenAI account | Language model inference for the Reasoning Plane. |
| Model deployments | Fast conversational, stronger reasoning, small classifier and embedding models. |
| Speech account | Streaming speech to text and real time text to speech for the avatar. |
| Content Safety account | Prompt and response screening for the Assurance Plane. |
| Private endpoints | Private connectivity for all three accounts. |
| Diagnostic settings | Model call audit to Log Analytics. |

## Posture

Every account is created with:

- `public_network_access_enabled = false` and `network_acls` default deny.
- `local_auth_enabled = false` so only Entra ID identities can call the service. No API keys exist to leak. Control KORU-C-13.
- A customer managed key using the shared encryption identity. Control KORU-C-22.
- A private endpoint into the private link subnet.

## Sovereignty of inference

Model deployments use regional `Standard` SKUs, not `Global`, so prompts and
completions are processed inside the jurisdiction. Cross Tasman routing of any
customer content is not permitted. Controls KORU-C-21 and KORU-C-30. Aligns to
APRA CPG 235 data risk across the AI lifecycle.

## Default models

| Role | Model | Deployment name |
|---|---|---|
| Conversational | `gpt-4o-mini` | `koru-fast` |
| Reasoning | `gpt-4o` | `koru-reason` |
| Classifier | `gpt-4o-mini` | `koru-classify` |
| Embedding | `text-embedding-3-large` | `koru-embed` |

Model names, versions and regional availability change often and must be
confirmed against current Azure documentation before use.

## Key inputs

`cmk_key_versionless_id`, `cmk_identity_id`, `cmk_identity_client_id` from the
security module, plus `private_endpoint_subnet_id` and `private_dns_zone_ids`
from network.

## Key outputs

`openai_account_id`, `openai_endpoint`, `speech_account_id`,
`content_safety_id`, `model_deployment_names`.
