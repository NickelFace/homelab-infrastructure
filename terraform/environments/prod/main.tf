terraform {
  required_version = ">= 1.7"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.7"
    }
  }
}

provider "libvirt" {
  uri = var.libvirt_uri
}

module "samba_dc" {
  source       = "../../modules/vm"
  name         = "samba-dc"
  memory_mb    = 4096
  vcpus        = 2
  disk_size_gb = 40
  network_name = var.network_name
  ssh_pubkey   = var.ssh_pubkey
}

module "mail_server" {
  source       = "../../modules/vm"
  name         = "mail"
  memory_mb    = 2048
  vcpus        = 2
  disk_size_gb = 30
  network_name = var.network_name
  ssh_pubkey   = var.ssh_pubkey
}

module "nginx_proxy" {
  source       = "../../modules/vm"
  name         = "nginx-proxy"
  memory_mb    = 1024
  vcpus        = 1
  disk_size_gb = 20
  network_name = var.network_name
  ssh_pubkey   = var.ssh_pubkey
}
