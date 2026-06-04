variable "name" {
  description = "VM hostname"
  type        = string
}

variable "memory_mb" {
  description = "RAM in megabytes"
  type        = number
  default     = 2048
}

variable "vcpus" {
  description = "Number of vCPUs"
  type        = number
  default     = 2
}

variable "disk_size_gb" {
  description = "OS disk size in GB"
  type        = number
  default     = 20
}

variable "storage_pool" {
  description = "libvirt storage pool name"
  type        = string
  default     = "default"
}

variable "base_image" {
  description = "Base cloud image volume name"
  type        = string
  default     = "ubuntu-24.04-cloud.qcow2"
}

variable "network_name" {
  description = "libvirt network to attach"
  type        = string
  default     = "default"
}

variable "ssh_pubkey" {
  description = "SSH public key injected via cloud-init"
  type        = string
}
