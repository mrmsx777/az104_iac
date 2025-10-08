
data "azurerm_client_config" "current" {}


data "azurerm_resource_group" "rg" {
  name     = local.rg_name
}



resource "azuread_user" "az104_user1" {
  user_principal_name = "az104-user1@xxjaximusxxgmail.onmicrosoft.com"
  display_name        = "az104-user1"
  password            = "pass@word1"
  account_enabled     = true
  job_title           = "IT Admin"
  department          = "IT"
}


resource "azuread_group" "itadmins" {
  display_name     = "IT Admins Group"
  mail_nickname    = "itadmins"
  security_enabled = true
  description      = "Group for az104 users"
  members          = [azuread_user.az104_user1.object_id]
}

#Example of map-object
variable "disks" {
  type = map(object({
    name                 = string
    location             = string
  }))
  default = {
    disk1 = {
      name                 = "test-managed-disk"
      location             = "East US"
    },
    disk2 = {
      name                 = "test-managed-disk-2"
      location             = "East US"
  }
}
}

resource "azurerm_managed_disk" "disks" {
  
  for_each             = { for k, v in var.disks : k => v if k != "disk1" }
  name                 = each.value.name
  location             = each.value.location
  resource_group_name  = data.azurerm_resource_group.rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb        = "32" 

}


variable "vnets" {
  type = map(object({
    name          = string
    address_space = list(string)  #< must be a list
    subnet_name1  = string
    subnet_prefix1 = string
    subnet_name2  = string
    subnet_prefix2 = string
  }))

  default = {
    vnet1 = {
      name           = "CoreServicesVnet"
      address_space  = ["10.20.0.0/16"]       # always list
      subnet_name1   = "SharedServicesSubnet"
      subnet_prefix1 = "10.20.10.0/24"
      subnet_name2   = "DatabaseSubnet"
      subnet_prefix2 = "10.20.20.0/24"
    }

    vnet2 = {
      name           = "ManufacturingVnet"
      address_space  = ["10.30.0.0/16"]       
      subnet_name1   = "SensorSubnet1"
      subnet_prefix1 = "10.30.20.0/24"
      subnet_name2   = "SensorSubnet2"
      subnet_prefix2 = "10.30.21.0/24"
    }
  }
}



resource "azurerm_virtual_network" "vnets" {
  for_each            = var.vnets
  name                = each.value.name
  location            = "East US"
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = each.value.address_space  

 
  subnet {
    name           = each.value.subnet_name1
    address_prefix = each.value.subnet_prefix1
  }

  subnet {
    name           = each.value.subnet_name2
    address_prefix = each.value.subnet_prefix2
  }
}



variable "vm1" {
  type = map(object({
    name = string
  }))

  default = {
    vm1 = { name = "test-win-vm1" }
    vm2 = { name = "test-win-vm2" }
  }
}




// The subnet is created inline inside the azurerm_virtual_network "vnets" resource
// so we don't need to look it up with a data block. We'll reference the
// created subnet through the virtual network resource below.



resource "azurerm_network_interface" "nic" {
  for_each            = var.vm1
  name                = "nic-${each.value.name}"
  location            = "East US"
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id = [for s in azurerm_virtual_network.vnets["vnet1"].subnet : s.id if s.name == var.vnets.vnet1.subnet_name1][0]  # id of SharedServicesSubnet created above
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_windows_virtual_machine" "vm1" {
  for_each            = var.vm1
  name                = each.value.name
  location            = "East US"
  resource_group_name = data.azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic[each.key].id] 
  size                = "Standard_B2s"
  admin_username      = "azureuser"
  admin_password      = "Pass@word1234"
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter-smalldisk"
    version   = "latest"
  }
}