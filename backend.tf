terraform {
  backend "azurerm" {

    resource_group_name  = "rg-az104"
    storage_account_name = "tfstatemsx1"  # e.g., tfstatesbx123
    container_name       = "tfstate"
    key                  = "labs.tfstate"
    use_azuread_auth     = true    
  }
}