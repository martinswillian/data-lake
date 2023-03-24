provider "aws" {
  region = "${var.region}"
}

module "datalake" {
  source  = "./modules"

  # AWS
  region          = var.region
  account_number  = var.account_number

  # Projeto
  name = var.name

  # EMR
  release_label         = var.release_label
  instance_type_master  = var.instance_type_master
  instance_type_core    = var.instance_type_core
  instance_count_core   = var.instance_count_core
  autoscaling_min       = var.autoscaling_min
  autoscaling_max       = var.autoscaling_max
  subnet_id             = var.subnet_id
}
