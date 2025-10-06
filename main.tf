# Handy to confirm which account/subscription is active
data "azurerm_client_config" "current" {}

# Minimal resource to validate auth + backend + plan/apply
data "azurerm_resource_group" "rg" {
  name     = local.rg_name
}



resource "azuread_user" "az104_user1" {
  user_principal_name = "az104-user1@elattariayoub1gmail.onmicrosoft.com"
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
  
  for_each             = var.disks
  name                 = each.value.name
  location             = each.value.location
  resource_group_name  = data.azurerm_resource_group.rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb        = "32" 

}