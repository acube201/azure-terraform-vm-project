output "vm_public_ip" {
  description = "The public IP address of the Virtual Machine"
  value       = azurerm_public_ip.vm_pip.ip_address
}

output "vm_admin_username" {
  description = "The admin username for the Virtual Machine"
  value       = azurerm_windows_virtual_machine.vm.admin_username
}
output "vm_name" {
  description = "The name of the Virtual Machine"
  value       = azurerm_windows_virtual_machine.vm.name
}
output "resource_group_name" {
  description = "The name of the Resource Group"
  value       = azurerm_resource_group.rg.name
}