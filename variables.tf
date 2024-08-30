variable "location" {
  description = " (Required) The location/region where the virtual network is created. Changing this forces a new resource to be created."
  type        = string
}

variable "rg_name" {
  description = "(Required) The name of the resource group in which to create the virtual network. Changing this forces a new resource to be created."
  type        = string
  default     = "rg_network"
}

variable "hub_vnet_name" {
  description = "The name of the  Hub Virtuel network"
  type        = string
  default     = "vnet_hub"
}

variable "spoke_vnet_name" {
  description = "The Spoke virtuel network name"
  type        = string
  default     = "vnet-spoke-001"
}

variable "vnet_address_space" {
  description = "(Required) The address space that is used the virtual network. You can supply more than one address space."
  type        = list(string)
}

variable "vnet_tags" {
  description = "A mapping of tags which should be assigned to the vnet"
  default     = {}
}

variable "subnet_nsg" {
  description = "Map of configuration settings for subnet and nsg "
  type = map(object({
    subnet_name       = string
    address_prefix    = list(string)
    service_endpoints = list(string)
    projet_tag        = optional(string)
    security_rules = map(object({
      priority                     = number
      access                       = string
      protocol                     = string
      source_port_range            = optional(string)
      source_port_ranges           = list(string)
      destination_port_ranges      = list(string)
      destination_port_range       = optional(string)
      source_address_prefixes      = list(string)
      source_address_prefix        = optional(string)
      destination_address_prefix   = optional(string)
      destination_address_prefixes = list(string)
      description                  = string
    }))
  }))
}