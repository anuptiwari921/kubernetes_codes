module "resource_group" {
  source                  = "../modules/azurerm_resource_group"
  resource_group_name     = "anuprg"
  resource_group_location = "centralindia"
}

module "virtual_network" {
  depends_on = [module.resource_group]
  source     = "../modules/azurerm_virtual_network"

  virtual_network_name     = "anupvnet"
  virtual_network_location = "centralindia"
  resource_group_name      = "anuprg"
  address_space            = ["10.0.0.0/16"]
}

module "frontend_subnet" {
  depends_on = [module.virtual_network]
  source     = "../modules/azurerm_subnet"

  resource_group_name  = "anuprg"
  virtual_network_name = "anupvnet"
  subnet_name          = "anupfrontend"
  address_prefixes     = ["10.0.1.0/24"]
}

module "backend_subnet" {
  depends_on = [module.virtual_network]
  source     = "../modules/azurerm_subnet"

  resource_group_name  = "anuprg"
  virtual_network_name = "anupvnet"
  subnet_name          = "backend-subnet"
  address_prefixes     = ["10.0.2.0/24"]
}

module "public_ip_frontend" {
  depends_on          = [module.resource_group]
  source              = "../modules/azurerm_public_ip"
  public_ip_name      = "pip-todoapp-frontend"
  resource_group_name = "anuprg"
  location            = "centralindia"
  allocation_method   = "Static"
}

module "frontend_vm" {
  depends_on = [module.frontend_subnet, module.key_vault, module.vm_username, module.vm_password, module.public_ip_frontend]
  source     = "../modules/azurerm_virtual_machine"

  resource_group_name  = "anuprg"
  location             = "centralindia"
  vm_name              = "vm-frontend"
  vm_size              = "Standard_B1s"
  admin_username       = "devopsadmin"
  image_publisher      = "Canonical"
  image_offer          = "0001-com-ubuntu-server-focal"
  image_sku            = "20_04-lts"
  image_version        = "latest"
  nic_name             = "nic-vm-frontend"
  frontend_ip_name     = "pip-todoapp-frontend"
  vnet_name            = "anupvnet"
  frontend_subnet_name = "anupfrontend"
  key_vault_name       = "securevaultap141"
  username_secret_name = "vmusername"
  password_secret_name = "vmpassword"
}

module "public_ip_backend" {
  depends_on          = [module.resource_group]
  source              = "../modules/azurerm_public_ip"
  public_ip_name      = "pip-todoapp-backend"
  resource_group_name = "anuprg"
  location            = "centralindia"
  allocation_method   = "Static"
}

module "backend_vm" {
  depends_on = [module.backend_subnet, module.key_vault, module.vm_username, module.vm_password, module.public_ip_backend]
  source     = "../modules/azurerm_virtual_machine"

  resource_group_name  = "anuprg"
  location             = "centralindia"
  vm_name              = "anupbackend"
  vm_size              = "Standard_B1s"
  admin_username       = "devopsadmin"
  image_publisher      = "Canonical"
  image_offer          = "0001-com-ubuntu-server-focal"
  image_sku            = "20_04-lts"
  image_version        = "latest"
  nic_name             = "nic-vm-backend"
  frontend_ip_name     = "pip-todoapp-backend"
  vnet_name            = "anupvnet"
  frontend_subnet_name = "backend-subnet"
  key_vault_name       = "securevaultap141"
  username_secret_name = "vmusername"
  password_secret_name = "vmpassword"
}

module "sql_server" {
  depends_on = [module.resource_group]
  source              = "../modules/azurerm_sql_server"
  sql_server_name     = "anupserver1200"
  resource_group_name = "anuprg"
  location            = "centralindia"
  # secret ko rakhne ka sudhar - Azure Key Vault
  administrator_login          = "sqladmin"
  administrator_login_password = "P@ssw0rd1234!"
}

module "sql_database" {
  depends_on          = [module.sql_server]
  source              = "../modules/azurerm_sql_database"
  sql_server_name     = "anupdatabase100"
  resource_group_name = "anuprg"
  sql_database_name   = "anupsqldatabase"
}

module "key_vault" {
  depends_on          = [module.resource_group]
  source              = "../modules/azurerm_key_vault"
  key_vault_name      = "securevaultap141"
  location            = "centralindia"
  resource_group_name = "anuprg"
}

module "vm_password" {
  source              = "../modules/azurerm_key_vault_secret"
  depends_on          = [module.key_vault]
  key_vault_name      = "securevaultap141"
  resource_group_name = "anuprg"
  secret_name         = "vmpassword"
  secret_value        = "P@ssw01rd@123"
}

module "vm_username" {
  source              = "../modules/azurerm_key_vault_secret"
  depends_on          = [module.key_vault]
  key_vault_name      = "securevaultap141"
  resource_group_name = "anuprg"
  secret_name         = "vmusername"
  secret_value        = "devopsadmin"
}

