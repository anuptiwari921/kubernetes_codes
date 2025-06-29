resource "azurerm_public_ip" "pip" {
    name = var.pip_name
    location = var.location_name
    resource_group_name = var.resource_group_name
   allocation_method = var.allocation_method_name
}
output "pip_id" {
  value = azurerm_public_ip.pip.id
}
