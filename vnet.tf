
#---------------------------------------------------------------------------------------------------------------------------------------------------#
## Vnet Configuration
#---------------------------------------------------------------------------------------------------------------------------------------------------#
data "azurerm_virtual_network" "hub" {
  name                = var.hub_vnet_name
  resource_group_name = var.rg_name
}

resource "azurerm_virtual_network" "spoke" {
  name                = var.spoke_vnet_name
  location            = var.location
  resource_group_name = data.azurerm_virtual_network.hub.rg_name
  address_space       = var.vnet_address_space
  tags                = var.vnet_tags
}

#---------------------------------------------------------------------------------------------------------------------------------------------------#
## Vnet Peering
#---------------------------------------------------------------------------------------------------------------------------------------------------#

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "peering-${var.hub_vnet_name}-to-${var.spoke_vnet_name}"
  resource_group_name       = azurerm_virtual_network.spoke.resource_group_name
  virtual_network_name      = data.azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.spoke.name
}
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "peering-${var.spoke_vnet_name}-to-${var.hub_vnet_name}"
  resource_group_name       = azurerm_virtual_network.spoke.resource_group_name
  virtual_network_name      = azurerm_virtual_network.spoke.name
  remote_virtual_network_id = data.azurerm_virtual_network.hub.name
  allow_gateway_transit     = true
}

#---------------------------------------------------------------------------------------------------------------------------------------------------#
## Subnets Configuration
#---------------------------------------------------------------------------------------------------------------------------------------------------#
resource "azurerm_subnet" "subnets" {
  for_each             = var.subnet_nsg
  name                 = "sub-${each.value.subnet_name}"
  address_prefixes     = each.value.address_prefix
  resource_group_name  = azurerm_virtual_network.spoke.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke.name
  service_endpoints    = each.value.service_endpoints
  lifecycle {
    ignore_changes = [delegation]
  }
}