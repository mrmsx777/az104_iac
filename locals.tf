locals {
  # Keep it dead simple for now
  location = "canadacentral"

  # Basic naming you can reuse later
  prefix = "lab"
  env    = "sbx"

  rg_name = "${local.prefix}-rg-${local.env}"

  tags = {
    owner = "ayoub"
    env   = local.env
    proj  = "az104"
  }
}