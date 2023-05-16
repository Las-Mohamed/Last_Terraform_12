 #### Création du Réseau Virtuel (Vnet) 
 resource "azurerm_virtual_network" "test" {
   name                = "Vnet"
   address_space       = ["10.0.0.0/16"]
   location            = data.azurerm_resource_group.Last_Brief12_terraform.location
   resource_group_name = data.azurerm_resource_group.Last_Brief12_terraform.name
 }

#### Création du Subnet (/24 sur le /16 du Vnet)
 resource "azurerm_subnet" "test" {
   name                 = "subNet"
   resource_group_name  = data.azurerm_resource_group.Last_Brief12_terraform.name
   virtual_network_name = azurerm_virtual_network.test.name
   address_prefixes     = ["10.0.2.0/24"]
 }

#### Création de l'Ip publique que l'on attribuera à notre LoadBalancer
 resource "azurerm_public_ip" "test" {
   name                         = "PublicIP_For_LB"
   location                     = data.azurerm_resource_group.Last_Brief12_terraform.location
   resource_group_name          = data.azurerm_resource_group.Last_Brief12_terraform.name
   allocation_method            = "Static"
 }
#### Création de nos 2 interfaces réseau à l'aide de "count"
  resource "azurerm_network_interface" "test" {
   count               = 2
   name                = "Network_Interface${count.index}"
   location            = data.azurerm_resource_group.Last_Brief12_terraform.location
   resource_group_name = data.azurerm_resource_group.Last_Brief12_terraform.name

   ip_configuration {
     name                          = "testConfiguration"
     subnet_id                     = azurerm_subnet.test.id
     private_ip_address_allocation = "dynamic"
   }
 }