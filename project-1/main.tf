provider "azurerm" {
  features {}
}

locals {
  tags = {
    environment = "${var.environment}"
  }
}

data "azurerm_resource_group" "main" {
  name = "${var.prefix}-rg"
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-vn"
  address_space       = ["10.0.0.0/24"]
  location            = var.location
  resource_group_name = data.azurerm_resource_group.main.name

  tags                = local.tags
}

resource "azurerm_subnet" "internal" {
  name                 = "${var.prefix}-internal"
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_network_security_group" "main" {
  name                = "${var.prefix}-nsg"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.main.name

  tags                = local.tags

  security_rule {
    name                       = "AllowVnetInBound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "AllowVnetOutBound"
    priority                   = 101
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }
  
  security_rule {
    name                       = "DenyAllInBound"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "main" {
  count               = var.vm_count

  name                = "${var.prefix}-nic-${count.index}"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = var.location

  tags                = local.tags

  ip_configuration {
    name                          = "${var.prefix}-ip-config"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_lb" "main" {
  name                = "${var.prefix}-lb"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.main.name

  tags                = local.tags

  frontend_ip_configuration {
    name                 = "${var.prefix}-lb-pip"
    public_ip_address_id = azurerm_public_ip.main.id
  }
}

resource "azurerm_lb_backend_address_pool" "main" {
  loadbalancer_id = azurerm_lb.main.id
  name            = "${var.prefix}-backend-address-pool"
  resource_group_name = data.azurerm_resource_group.main.name
}

resource "azurerm_network_interface_backend_address_pool_association" "main" {
  count                   = var.vm_count

  network_interface_id    = azurerm_network_interface.main[count.index].id
  ip_configuration_name   = "${var.prefix}-ip-config"
  backend_address_pool_id = azurerm_lb_backend_address_pool.main.id
}

resource "azurerm_availability_set" "main" {
  name                = "${var.prefix}-availability-set"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.main.name

  tags                = local.tags
}

data "azurerm_image" "packer-image" {
  name                = "project1-packer-image"
  resource_group_name = data.azurerm_resource_group.main.name
}

resource "azurerm_linux_virtual_machine" "main" {
  count                           = var.vm_count

  name                            = "${var.prefix}-vm-${count.index}"
  resource_group_name             = data.azurerm_resource_group.main.name
  location                        = var.location
  size                            = "Standard_D2s_v3"
  admin_username                  = "${var.username}"
  admin_password                  = "${var.password}"
  disable_password_authentication = false
  availability_set_id             = azurerm_availability_set.main.id
  network_interface_ids = [
    azurerm_network_interface.main[count.index].id,
  ]

  source_image_id = data.azurerm_image.packer-image.id

  tags                            = local.tags

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}

resource "azurerm_managed_disk" "main" {
  count                = var.vm_count

  name                 = "${var.prefix}-managed-disk-${count.index}"
  location             = var.location
  resource_group_name  = data.azurerm_resource_group.main.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 1

  tags                 = local.tags
}

resource "azurerm_public_ip" "main" {
  name                = "${var.prefix}-pip"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = var.location
  allocation_method   = "Static"

  tags                = local.tags
}