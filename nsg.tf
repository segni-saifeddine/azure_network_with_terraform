resource "azurerm_network_security_group" "nsgs" {
  for_each            = var.subnet_nsg
  name                = "nsg-${each.value.subnet_name}"
  resource_group_name = azurerm_virtual_network.spoke.resource_group_name
  location            = var.location
  dynamic "security_rule" {
    for_each = each.value.security_rules
    content {
      name                         = security_rule.key
      direction                    = each.value.direction
      priority                     = security_rule.value.priority
      access                       = security_rule.value.access
      protocol                     = security_rule.value.protocol
      source_port_ranges           = security_rule.value.source_port_ranges
      source_port_range            = lookup(security_rule.value, "source_port_range", "")
      destination_port_ranges      = security_rule.value.destination_port_ranges
      destination_port_range       = lookup(security_rule.value, "destination_port_range", "")
      source_address_prefix        = lookup(security_rule.value, "source_address_prefix", null)
      source_address_prefixes      = security_rule.value.source_address_prefixes
      destination_address_prefix   = lookup(security_rule.value, "destination_address_prefix", null)
      destination_address_prefixes = security_rule.value.destination_address_prefixes
      description                  = security_rule.value.description
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "association" {
  for_each                  = var.subnet_nsg
  subnet_id                 = azurerm_subnets.subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.nsgs[each.key].id
}