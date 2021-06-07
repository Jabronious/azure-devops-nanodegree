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
    a. `terraform init`  
    a. `terraform plan -out solution.plan` - Input number of VM's you require. Also, at this step there are options that can be ran to change default. See (var.tf)[https://github.com/Jabronious/azure-devops-nanodegree/blob/main/project-1/vars.tf]. Just run it like this `terraform plan -out soultion.plan -var VAR_NAME=VALUE`  
    b. `terraform apply "solution.plan"`  
4. When you are finished with you infrastructure ensure you run `terraform destroy` from the repo!

### Output
There is no output directly from terraform in this iteration. However, you will requisition everything you need to run this web server with the number of necessary VM's for it. These VM's will run the packer template deployed in Step 2 and they will run behind a load balancer.

