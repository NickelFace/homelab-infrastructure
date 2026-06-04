output "ip_address" {
  description = "VM IP address assigned by DHCP"
  value       = libvirt_domain.vm.network_interface[0].addresses[0]
}

output "vm_name" {
  description = "VM domain name in libvirt"
  value       = libvirt_domain.vm.name
}
