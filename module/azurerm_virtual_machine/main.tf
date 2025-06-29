resource "azurerm_network_interface" "nic"{
    name = var.nic_name
    location = var.location_name
    resource_group_name = var.resource_group_name
ip_configuration {
  name = "internal"
  subnet_id = var.subnet_id_name
  private_ip_address_allocation = "Dynamic"
  public_ip_address_id = var.public_ip_address_id
}
}
resource "azurerm_linux_virtual_machine" "vm"{
    name = var.vm_name
    location = var.location_name
    resource_group_name = var.resource_group_name
    size = var.size_name
    admin_username = var.admin_username
    admin_password = var.admin_password
    disable_password_authentication =false
    network_interface_ids = [azurerm_network_interface.nic.id]
os_disk {
  caching = "ReadWrite"
  storage_account_type = "Standard_LRS"
}
source_image_reference {
  publisher = var.publisher_name
  offer = var.offer_name
  sku = var.sku_name
  version = "latest"
}
}

