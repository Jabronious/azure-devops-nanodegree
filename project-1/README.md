# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

## Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

## Getting Started

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions
1. Create a resource group via Azure CLI or Azure GUI. 
2. Run `packer build server.json` from the root of the repo. You will need to have been authenticated through the Azure CLI though as it uses that method for authentication. 
3. Run terraform:
    ```
    If you wish to change of the default values you can edit them in the var.tf file:
    "prefix" - This will be prepended on all resources to identify them easier
    "location" - The Azure Region in which all resources should be created in
    "username" - the username used for the VM's
    "password" - the password used for the VM's
    "vm_count" - The number of VM's that are required. Validation is ran to ensure at least 2 and no more than 5
    "environment" - The envrionment that this VM will be deployed in. This also creates a tag on all resources with this value
    ```
    a. `terraform init` 
    b. `terraform plan -out solution.plan` - Input number of VM's you require. Also, at this step there are options that can be ran to change default. See (var.tf)[https://github.com/Jabronious/azure-devops-nanodegree/blob/main/project-1/vars.tf]. Just run it like this `terraform plan -out soultion.plan -var VAR_NAME=VALUE`  
    c. `terraform apply "solution.plan"`  
4. When you are finished with you infrastructure ensure you run `terraform destroy` from the repo!

### Output
If this is your first run to applying the terraform infrastructure then you should see something similar to this:  
`Apply complete! Resources: 15 added, 0 changed, 0 destroyed.`  
**15 resource added is if you deploy 2 VM (Default option)**
- [Virtual Network] x1
- [Subnet] x1
- [Network Security Group] x1
- [Network Interface] x2
- [Load Balancer] x1
- [Load Balancer Backend Pool Association] x1
- [Network Interface Backend Address Pool Association] x2
- [Availaiblity Set] x1
- [Linux Virtual Machine] x2
- [Managed Disk] x2
- [Public IP Address] x1
