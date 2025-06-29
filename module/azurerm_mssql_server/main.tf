resource "azurerm_mssql_server" "sqlserver" {
  name                         = var.sqlserver_name
  resource_group_name          = var.resource_group_name
  location                     = var.location_name
  version                      = var.version_name
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
 }
