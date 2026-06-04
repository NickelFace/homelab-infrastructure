variable "libvirt_uri" {
  description = "libvirt connection URI"
  type        = string
  default     = "qemu:///system"
}

variable "network_name" {
  description = "libvirt network name"
  type        = string
  default     = "default"
}

variable "ssh_pubkey" {
  description = "SSH public key for VM access"
  type        = string
}
