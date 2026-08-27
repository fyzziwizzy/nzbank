# Module: network

Foundation network for a Project Koru deployment. Everything else is placed
inside the resource group, virtual network and subnets this module creates, and
reaches Azure PaaS only over the private endpoints and private DNS zones defined
here.

## What it builds

| Resource | Purpose |
|---|---|
| Resource group | Platform resource group for the whole environment. |
| Virtual network | Single VNet per environment and region. |
| Subnets | `snet-edge`, `snet-runtime` (delegated to `Microsoft.App/environments`), `snet-privatelink`, `snet-apim`, `AzureFirewallSubnet`, `AzureBastionSubnet`. |
| Network security groups | Deny by default with a documented allow set per subnet. |
| Azure Firewall and policy | Egress inspection with an explicit FQDN allow list and control plane network rules. |
| Route table | Forces `0.0.0.0/0` from the workload subnets through the firewall. |
| Azure Bastion | Break glass administrative access with no public RDP or SSH. |
| Private DNS zones | One per PaaS service, each linked to the VNet. |
| `private_endpoint` submodule | Reusable primitive consumed by every other module. |

## Sovereignty

The resource group carries a `precondition` that fails the plan if `location`
is not in `allowed_locations` for the jurisdiction. A New Zealand deployment
cannot be pointed at an Australian region and vice versa. This is the hard no
cross Tasman rule from the programme canon, enforced in code. Control KORU-C-21.

## Controls

| Control | Where |
|---|---|
| KORU-C-21 jurisdiction lock | Resource group `precondition`. |
| KORU-C-23 segmentation | Per subnet NSGs, deny by default. |
| KORU-C-24 private connectivity | Private DNS zones and the reusable private endpoint submodule. |
| KORU-C-25 egress control | Azure Firewall policy FQDN allow list and forced tunnelling. |
| KORU-C-14 privileged access | Azure Bastion, no public management ports. |

Standards: APRA CPS 234 (access restriction, network security), RBNZ BS11
(outsourcing and isolation of banking services).

## Key inputs

| Variable | Notes |
|---|---|
| `vnet_address_space` | Non overlapping per environment and region. See environment READMEs. |
| `subnet_prefixes` | Object with `edge`, `runtime`, `privatelink`, `apim`, `firewall`, `bastion`. |
| `allowed_locations` | Regions permitted for the jurisdiction. Drives the sovereignty precondition. |
| `allowed_egress_fqdns` | Firewall application rule allow list. |
| `firewall_sku_tier` | `Premium` in production for TLS inspection and IDPS. |
| `deploy_bastion` | Disable in cost sensitive environments. |

## Key outputs

`resource_group_name`, `subnet_ids`, `private_endpoint_subnet_id`,
`runtime_subnet_id`, `apim_subnet_id`, `private_dns_zone_ids`,
`firewall_private_ip`.

## Notes

The `AzureFirewallSubnet` deliberately has no NSG, which the platform requires.
The runtime subnet needs at least a `/23` for the Container Apps workload
profile environment.
