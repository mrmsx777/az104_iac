locals {
  rg_name = "lab_project"

  tags = {
    owner = "msx"
    env   = "dev"
    proj  = "az104"
    app = "az104_iac"
  }
}