 resource "azurerm_virtual_network" "test" {
   name                = "Vnet"
   address_space       = ["10.0.0.0/16"]
   location            = azurerm_resource_group.imported_rg.location
   resource_group_name = azurerm_resource_group.imported_rg.name
 }

 resource "azurerm_subnet" "test" {
   name                 = "subNet"
   resource_group_name  = azurerm_resource_group.imported_rg.name
   virtual_network_name = azurerm_virtual_network.test.name
   address_prefixes     = ["10.0.2.0/24"]
 }

 resource "azurerm_public_ip" "test" {
   name                         = "PublicIP_For_LB"
   location                     = azurerm_resource_group.imported_rg.location
   resource_group_name          = azurerm_resource_group.imported_rg.name
   allocation_method            = "Static"
 }

  resource "azurerm_network_interface" "test" {
   count               = 2
   name                = "Network_Interface${count.index}"
   location            = azurerm_resource_group.imported_rg.location
   resource_group_name = azurerm_resource_group.imported_rg.name

   ip_configuration {
     name                          = "testConfiguration"
     subnet_id                     = azurerm_subnet.test.id
     private_ip_address_allocation = "dynamic"
   }
 }