# AWS
variable "region" {
}
variable "account_number" {
}

# Projeto
variable "name" {
}

# EMR
variable "release_label" {
}
variable "instance_type_master" {
}
variable "instance_type_core" {
}
variable "instance_count_core" {
}
variable "autoscaling_min" {
  type = number
}
variable "autoscaling_max" {
  type = number
}
variable "subnet_id" {
}
