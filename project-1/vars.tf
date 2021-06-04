variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  default = "project1"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default = "East US"
}

variable "username" {
  description = "username"
  default = "adminTest"
}

variable "password" {
  description = "password"
  default = "topSecretPass1234"
}

variable "vm_count" {
    description = "The number of VM's that are required."
}

variable "environment" {
  description = "The envrionment that this VM will be deployed in."
  default = "DEV"
}