
#### Afin de récupérer l'Ip privée de nos VM, on fait appel à la variable correspondant à l'interface réseau,
#### grâce au meta-argument "count", nous avons 2 Interfaces réseau. Il faut donc faire correspondre les éléments voulus
#### count[0] ou count [1], ici azurerm_network_interface.test[0].private_ip_address correspond à l'Ip de l'interface réseau 0
output "Ip_VM1" {
  value = azurerm_network_interface.test[0].private_ip_address
}

output "Ip_VM2" {
  value = azurerm_network_interface.test[1].private_ip_address
}

#### On fait appel, à la ressource azurerm_public_ip qui se trouve dans le module network.tf
output "IpPub_LoadBalancer" {
  value = azurerm_public_ip.test.ip_address
}

#### On fait appel à la datasource pour renseigner le nom/région du resource group
output "Ressource_Group" {
  value = data.azurerm_resource_group.Last_Brief12_terraform.name
}

output "Region" {
  value = data.azurerm_resource_group.Last_Brief12_terraform.location
}
