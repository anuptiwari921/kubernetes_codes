module "resource_group_name" {
  source              = "../module/azurerm_resource_group"
  resource_group_name = "rg-todo"
  location_name       = "west us"
}
module "vnet" {
  source              = "../module/azurerm_vnet"
  depends_on          = [module.resource_group_name]
  vnet_name           = "vnet-todo"
  location_name       = "west us"
  resource_group_name = "rg-todo"
  address_space_name  = ["10.0.0.0/16"]
}
module "subnet" {
  source                = "../module/azurerm_subnet"
  depends_on            = [module.vnet]
  subnet_name           = "subnet-todo"
  resource_group_name   = "rg-todo"
  vnet_name             = "vnet-todo"
  address_prefixes_name = ["10.0.0.0/24"]
}
module "pip" {
  source                 = "../module/azurerm_pip"
  pip_name               = "pip-todo"
  location_name          = "west us"
  resource_group_name    = "rg-todo"
  allocation_method_name = "Static"

}
module "vm-todo" {
  source               = "../module/azurerm_virtual_machine"
  depends_on           = [module.subnet]
  resource_group_name  = "rg-todo"
  location_name        = "west us"
  vm_name              = "vm-todo"
  size_name            = "Standard_F2"
  admin_username       = "Rajnish"
  admin_password       = "R@jnish1988"
  publisher_name       = "canonical"
  offer_name           = "0001-com-ubuntu-server-jammy"
  sku_name             = "22_04-lts"
  nic_name             = "nic-todo"
  subnet_id_name       = module.subnet.subnet_id
  public_ip_address_id = module.pip.pip_id

}


