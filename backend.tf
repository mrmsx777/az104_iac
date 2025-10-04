terraform {
  backend "azurerm" {

    resource_group_name  = "lab_project"
    storage_account_name = "tfstatemsx777"  # e.g., tfstatesbx123
    container_name       = "tfstate"
    key                  = "labs.tfstate"
    use_azuread_auth     = true    
  }
}