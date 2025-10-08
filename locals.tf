locals {
  rg_name = "rg-az104"
  localion  = "eastus"

  tags = {
    owner = "msx"
    env   = "dev"
    proj  = "az104"
    app = "az104_iac"
  }
}