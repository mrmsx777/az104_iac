#define user variable here that will suply main.tf file
location = "canadacentral"
rg_name  = "rg-az104"
tags = {
  owner = "msx"
  env   = "dev"
  proj  = "az104"
  app = "az104_iac"
}
