#### Création de datadisks 20Gio pour ensuite les attribuer à nos VM's
    resource "azurerm_managed_disk" "test" {
   count                = 2
   name                 = "datadisk${count.index}"
   location             = data.azurerm_resource_group.Last_Brief12_terraform.location
   resource_group_name  = data.azurerm_resource_group.Last_Brief12_terraform.name
   storage_account_type = "Standard_LRS"
   create_option        = "Empty"
   disk_size_gb         = "20"
 }

#### Création d'un groupe à haute disponibilité 
  resource "azurerm_availability_set" "avset" {
   name                         = "avset"
   location                     = data.azurerm_resource_group.Last_Brief12_terraform.location
   resource_group_name          = data.azurerm_resource_group.Last_Brief12_terraform.name
   platform_fault_domain_count  = 2
   platform_update_domain_count = 2
   managed                      = true
 }

#### Création des VM avec "count" qui permet de délimiter le nombre de VM à 2
 resource "azurerm_virtual_machine" "test" {
   count                 = 2
   name                  = "VM${count.index}"
   location              = data.azurerm_resource_group.Last_Brief12_terraform.location
   availability_set_id   = azurerm_availability_set.avset.id
   resource_group_name   = data.azurerm_resource_group.Last_Brief12_terraform.name
   network_interface_ids = [element(azurerm_network_interface.test.*.id, count.index)]
   vm_size               = "Standard_DS1_v2"

#### Cette ligne est facultative, elle permet de supprimer automatiquement l'OS disk lors de la suppression de la VM
    delete_os_disk_on_termination = true

#### Cette ligne est facultative, elle permet de supprimer automatiquement le data disk lors de la suppression de la VM
    delete_data_disks_on_termination = true

#### Image choisie pour les VM's
   storage_image_reference {
     publisher = "Canonical"
     offer     = "UbuntuServer"
     sku       = "16.04-LTS"
     version   = "latest"
   }
#### Type de disk pour l'OS
   storage_os_disk {
     name              = "OSdisk${count.index}"
     caching           = "ReadWrite"
     create_option     = "FromImage"
     managed_disk_type = "Standard_LRS"
   }
#### Disque data supplémentaire attaché à nos VM's
   storage_data_disk {
     name            = element(azurerm_managed_disk.test.*.name, count.index)
     managed_disk_id = element(azurerm_managed_disk.test.*.id, count.index)
     create_option   = "Attach"
     lun             = 1
     disk_size_gb    = element(azurerm_managed_disk.test.*.disk_size_gb, count.index)
   }
#### Paramètres de connexion ADMIN
   os_profile {
     computer_name  = "hostname"
     admin_username = "testadmin"
     admin_password = "Password1234!"
   }

   os_profile_linux_config {
     disable_password_authentication = false
   }

   tags = {
     environment = "TEST_BRIEF"
   }
 }