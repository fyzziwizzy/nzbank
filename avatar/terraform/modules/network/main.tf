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

  # Private DNS zones for every PaaS service reached over private link. Zone
  # names are fixed by Microsoft. The Kusto zone is region scoped. Registering
  # these zones and linking them to the VNet is what makes private endpoint DNS
  # resolution work without exposing anything publicly. Control KORU-C-24.
  private_dns_zones = {
    vault             = "privatelink.vaultcore.azure.net"
    blob              = "privatelink.blob.core.windows.net"
    file              = "privatelink.file.core.windows.net"
    queue             = "privatelink.queue.core.windows.net"
    table             = "privatelink.table.core.windows.net"
    dfs               = "privatelink.dfs.core.windows.net"
    openai            = "privatelink.openai.azure.com"
    cognitiveservices = "privatelink.cognitiveservices.azure.com"
    search            = "privatelink.search.windows.net"
    cosmos_sql        = "privatelink.documents.azure.com"
    acr               = "privatelink.azurecr.io"
    servicebus        = "privatelink.servicebus.windows.net"
    redis             = "privatelink.redis.cache.windows.net"
    appconfig         = "privatelink.azconfig.io"
    monitor           = "privatelink.monitor.azure.com"
    monitor_oms       = "privatelink.oms.opinsights.azure.com"
    monitor_ods       = "privatelink.ods.opinsights.azure.com"
    monitor_agentsvc  = "privatelink.agentsvc.azure-automation.net"
    kusto             = "privatelink.${var.location}.kusto.windows.net"
  }
}

# ---------------------------------------------------------------------------
# Platform resource group. Created here because the network is the first thing
# stood up and everything else is placed alongside it.
# ---------------------------------------------------------------------------
resource "azurerm_resource_group" "this" {
  name     = "${local.name_prefix}-rg-${local.suffix}"
  location = var.location
  tags     = var.tags

  lifecycle {
    # Sovereignty enforced in code. A New Zealand deployment cannot be pointed
    # at an Australian region and vice versa. Implements the hard no cross
    # Tasman rule from the programme canon. Control KORU-C-21.
    precondition {
      condition     = contains(var.allowed_locations, var.location)
      error_message = "location ${var.location} is not permitted for jurisdiction ${var.jurisdiction}. Cross Tasman placement is blocked."
    }
  }
}

# ---------------------------------------------------------------------------
# Virtual network and subnets.
# ---------------------------------------------------------------------------
resource "azurerm_virtual_network" "this" {
  name                = "${local.name_prefix}-vnet-${local.suffix}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = var.vnet_address_space
  dns_servers         = var.dns_servers
  tags                = var.tags
}

resource "azurerm_subnet" "edge" {
  name                 = "snet-edge"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_prefixes.edge]
}

# Runtime subnet is delegated to the Container Apps managed environment. The
# delegation hands subnet management to the platform for the workload profile.
resource "azurerm_subnet" "runtime" {
  name                 = "snet-runtime"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_prefixes.runtime]

  delegation {
    name = "aca-delegation"
    service_delegation {
      name    = "Microsoft.App/environments"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# Private endpoint subnet. Network policies are disabled so private endpoint
# NICs can be placed here.
resource "azurerm_subnet" "privatelink" {
  name                              = "snet-privatelink"
  resource_group_name               = azurerm_resource_group.this.name
  virtual_network_name              = azurerm_virtual_network.this.name
  address_prefixes                  = [var.subnet_prefixes.privatelink]
  private_endpoint_network_policies = "Disabled"
}

resource "azurerm_subnet" "apim" {
  name                 = "snet-apim"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_prefixes.apim]
}

# The firewall subnet name is fixed by the platform and must not carry an NSG.
resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_prefixes.firewall]
}

# The bastion subnet name is fixed by the platform.
resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_prefixes.bastion]
}

# ---------------------------------------------------------------------------
# Network security groups. Each is deny by default with a documented allow set.
# Control KORU-C-23 network segmentation, aligned to APRA CPS 234 access
# restriction expectations.
# ---------------------------------------------------------------------------

# Edge subnet. Accepts inbound only from the Front Door backend service tag.
resource "azurerm_network_security_group" "edge" {
  name                = "nsg-${local.name_prefix}-edge-${local.suffix}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags

  security_rule {
    name                       = "Allow-FrontDoor-Inbound-443"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "AzureFrontDoor.Backend"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "Deny-All-Inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Runtime subnet. Accepts inbound from the APIM and edge subnets only.
resource "azurerm_network_security_group" "runtime" {
  name                = "nsg-${local.name_prefix}-runtime-${local.suffix}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags

  security_rule {
    name                       = "Allow-Apim-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = var.subnet_prefixes.apim
    destination_address_prefix = var.subnet_prefixes.runtime
  }

  security_rule {
    name                       = "Allow-Edge-Inbound"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = var.subnet_prefixes.edge
    destination_address_prefix = var.subnet_prefixes.runtime
  }

  security_rule {
    name                       = "Allow-Intra-Subnet"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.subnet_prefixes.runtime
    destination_address_prefix = var.subnet_prefixes.runtime
  }

  security_rule {
    name                       = "Deny-All-Inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Private endpoint subnet. Inbound only from within the VNet.
resource "azurerm_network_security_group" "privatelink" {
  name                = "nsg-${local.name_prefix}-pl-${local.suffix}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags

  security_rule {
    name                       = "Allow-VNet-Inbound-443"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "Deny-All-Inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# APIM subnet. Internal mode requires the platform control plane, load balancer
# health probe and client traffic. These rules are mandated by the service.
resource "azurerm_network_security_group" "apim" {
  name                = "nsg-${local.name_prefix}-apim-${local.suffix}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags

  security_rule {
    name                       = "Allow-Apim-Management-3443"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3443"
    source_address_prefix      = "ApiManagement"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "Allow-LB-Health-6390"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "6390"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "Allow-Client-443"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "Deny-All-Inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Bastion subnet NSG. The rule set is mandated by the Azure Bastion service.
resource "azurerm_network_security_group" "bastion" {
  count = var.deploy_bastion ? 1 : 0

  name                = "nsg-${local.name_prefix}-bastion-${local.suffix}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags

  security_rule {
    name                       = "Allow-HTTPS-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-GatewayManager-Inbound"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "GatewayManager"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-AzureLoadBalancer-Inbound"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-BastionHostComms-Inbound"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_ranges    = ["8080", "5701"]
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "Allow-SshRdp-Outbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "3389"]
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "Allow-AzureCloud-Outbound-443"
    priority                   = 110
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "AzureCloud"
  }

  security_rule {
    name                       = "Allow-BastionHostComms-Outbound"
    priority                   = 120
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_ranges    = ["8080", "5701"]
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "Allow-GetSessionInfo-Outbound"
    priority                   = 130
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }
}

resource "azurerm_subnet_network_security_group_association" "edge" {
  subnet_id                 = azurerm_subnet.edge.id
  network_security_group_id = azurerm_network_security_group.edge.id
}

resource "azurerm_subnet_network_security_group_association" "runtime" {
  subnet_id                 = azurerm_subnet.runtime.id
  network_security_group_id = azurerm_network_security_group.runtime.id
}

resource "azurerm_subnet_network_security_group_association" "privatelink" {
  subnet_id                 = azurerm_subnet.privatelink.id
  network_security_group_id = azurerm_network_security_group.privatelink.id
}

resource "azurerm_subnet_network_security_group_association" "apim" {
  subnet_id                 = azurerm_subnet.apim.id
  network_security_group_id = azurerm_network_security_group.apim.id
}

resource "azurerm_subnet_network_security_group_association" "bastion" {
  count = var.deploy_bastion ? 1 : 0

  subnet_id                 = azurerm_subnet.bastion.id
  network_security_group_id = azurerm_network_security_group.bastion[0].id
}

# ---------------------------------------------------------------------------
# Azure Firewall and policy. All egress is inspected and constrained to an
# explicit FQDN allow list. Control KORU-C-25 egress control, supporting the
# data exfiltration protections expected under CPS 234 and BS11.
# ---------------------------------------------------------------------------
resource "azurerm_public_ip" "firewall" {
  name                = "pip-${local.name_prefix}-fw-${local.suffix}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  tags                = var.tags
}

resource "azurerm_firewall_policy" "this" {
  name                     = "afwp-${local.name_prefix}-${local.suffix}"
  location                 = azurerm_resource_group.this.location
  resource_group_name      = azurerm_resource_group.this.name
  sku                      = var.firewall_sku_tier
  threat_intelligence_mode = "Deny"
  tags                     = var.tags

  dns {
    proxy_enabled = true
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "egress" {
  name               = "rcg-koru-egress"
  firewall_policy_id = azurerm_firewall_policy.this.id
  priority           = 500

  # Application rules restrict outbound HTTPS to a named FQDN allow list. Any
  # destination not on the list is denied. This is the exfiltration guard rail.
  application_rule_collection {
    name     = "arc-koru-allow-fqdn"
    priority = 500
    action   = "Allow"

    rule {
      name = "allow-platform-fqdns"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = var.vnet_address_space
      destination_fqdns = var.allowed_egress_fqdns
    }
  }

  # Network rules for control plane dependencies that use service tags.
  network_rule_collection {
    name     = "nrc-koru-platform"
    priority = 400
    action   = "Allow"

    rule {
      name                  = "allow-azure-monitor"
      protocols             = ["TCP"]
      source_addresses      = var.vnet_address_space
      destination_addresses = ["AzureMonitor"]
      destination_ports     = ["443", "1886"]
    }

    rule {
      name                  = "allow-azure-active-directory"
      protocols             = ["TCP"]
      source_addresses      = var.vnet_address_space
      destination_addresses = ["AzureActiveDirectory"]
      destination_ports     = ["443"]
    }

    rule {
      name                  = "allow-ntp"
      protocols             = ["UDP"]
      source_addresses      = var.vnet_address_space
      destination_addresses = ["*"]
      destination_ports     = ["123"]
    }
  }
}

resource "azurerm_firewall" "this" {
  name                = "afw-${local.name_prefix}-${local.suffix}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku_name            = "AZFW_VNet"
  sku_tier            = var.firewall_sku_tier
  firewall_policy_id  = azurerm_firewall_policy.this.id
  zones               = ["1", "2", "3"]
  tags                = var.tags

  ip_configuration {
    name                 = "ipconfig-primary"
    subnet_id            = azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }
}

# ---------------------------------------------------------------------------
# Route table forcing all egress from the workload subnets through the firewall.
# ---------------------------------------------------------------------------
resource "azurerm_route_table" "egress" {
  name                = "rt-${local.name_prefix}-egress-${local.suffix}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags

  route {
    name                   = "default-to-firewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.this.ip_configuration[0].private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "runtime" {
  subnet_id      = azurerm_subnet.runtime.id
  route_table_id = azurerm_route_table.egress.id
}

resource "azurerm_subnet_route_table_association" "edge" {
  subnet_id      = azurerm_subnet.edge.id
  route_table_id = azurerm_route_table.egress.id
}

# ---------------------------------------------------------------------------
# Azure Bastion for break glass administrative access. No public RDP or SSH is
# ever exposed. Control KORU-C-14 privileged access.
# ---------------------------------------------------------------------------
resource "azurerm_public_ip" "bastion" {
  count = var.deploy_bastion ? 1 : 0

  name                = "pip-${local.name_prefix}-bas-${local.suffix}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_bastion_host" "this" {
  count = var.deploy_bastion ? 1 : 0

  name                = "bas-${local.name_prefix}-${local.suffix}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "Standard"
  tags                = var.tags

  ip_configuration {
    name                 = "ipconfig-primary"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion[0].id
  }
}

# ---------------------------------------------------------------------------
# Private DNS zones and virtual network links for every PaaS service.
# ---------------------------------------------------------------------------
resource "azurerm_private_dns_zone" "this" {
  for_each = local.private_dns_zones

  name                = each.value
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each = local.private_dns_zones

  name                  = "vnl-${each.key}-${local.suffix}"
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.this[each.key].name
  virtual_network_id    = azurerm_virtual_network.this.id
  registration_enabled  = false
  tags                  = var.tags
}
