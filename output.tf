output "Ip_VM1" {
  value = azurerm_network_interface.test[0].private_ip_address
}

output "Ip_VM2" {
  value = azurerm_network_interface.test[1].private_ip_address
}

output "IpPub_LoadBalancer" {
  value = azurerm_public_ip.test.ip_address
}

output "Ressource_Group" {
  value = azurerm_resource_group.imported_rg.name
}

output "Region" {
  value = azurerm_resource_group.imported_rg.location
}
