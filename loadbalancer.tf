 resource "azurerm_lb" "test" {
   name                = "LoadBalancer"
   location            = azurerm_resource_group.imported_rg.location
   resource_group_name = azurerm_resource_group.imported_rg.name

   frontend_ip_configuration {
     name                 = "publicIPAddress"
     public_ip_address_id = azurerm_public_ip.test.id
   }
 }

 resource "azurerm_lb_backend_address_pool" "test" {
   loadbalancer_id     = azurerm_lb.test.id
   name                = "BackEndAddressPool"
 }