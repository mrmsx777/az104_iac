# Handy to confirm which account/subscription is active
data "azurerm_client_config" "current" {}

# Minimal resource to validate auth + backend + plan/apply
data "azurerm_resource_group" "rg" {
  name     = local.rg_name
  tags     = local.tags
}



resource "azuread_user" "az104_user1" {
  user_principal_name = "az104-user1@elattariayoub1gmail.onmicrosoft.com"
  display_name        = "az104-user1"
  password            = "pass@word1"
  account_enabled     = true
  job_title           = "IT Admin"
  department          = "IT"
}