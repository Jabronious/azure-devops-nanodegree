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
    default = 2
    validation {
      condition     = var.vm_count >= 2 && var.vm_count <= 5
      error_message = "You need at least 2 VMs and less than or equal to 5."
    }
}

variable "environment" {
  description = "The envrionment that this VM will be deployed in."
  default = "DEV"
}