# -------------------------
# Resource Group
# -------------------------
resource "azurerm_resource_group" "rg" {
  name     = "myTFResourceGroup"
  location = "East US 2"
}

# -------------------------
# Virtual Network
# -------------------------
resource "azurerm_virtual_network" "vnet" {
  name                = "myTFVNet2"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# -------------------------
# Subnet
# -------------------------
resource "azurerm_subnet" "subnet" {
  name                 = "myTFSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# -------------------------
# Public IP
# -------------------------
resource "azurerm_public_ip" "vm_pip" {
  name                = "myTFPublicIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard" # Must be Standard for Static
}

# -------------------------
# Network Security Group
# -------------------------
resource "azurerm_network_security_group" "nsg" {
  name                = "myTFNSG"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# -------------------------
# NSG Association
# -------------------------
resource "azurerm_subnet_network_security_group_association" "subnet_assoc" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# -------------------------
# Network Interface
# -------------------------
resource "azurerm_network_interface" "nic" {
  name                = "myTFNic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_pip.id
  }
}

# -------------------------
# Windows Virtual Machine
# -------------------------
resource "azurerm_windows_virtual_machine" "vm" {
  name                = "myTFVM"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_D2_v3" # Reliable size in East US

  admin_username = "azureuser"
  admin_password = var.admin_password

  network_interface_ids = [azurerm_network_interface.nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}
