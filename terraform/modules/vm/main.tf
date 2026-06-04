terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.7"
    }
  }
}

resource "libvirt_volume" "os_disk" {
  name             = "${var.name}-os.qcow2"
  pool             = var.storage_pool
  base_volume_name = var.base_image
  format           = "qcow2"
  size             = var.disk_size_gb * 1073741824
}

resource "libvirt_cloudinit_disk" "init" {
  name      = "${var.name}-init.iso"
  pool      = var.storage_pool
  user_data = templatefile("${path.module}/cloud-init.tpl", {
    hostname    = var.name
    ssh_pubkey  = var.ssh_pubkey
  })
}

resource "libvirt_domain" "vm" {
  name   = var.name
  memory = var.memory_mb
  vcpu   = var.vcpus

  cloudinit = libvirt_cloudinit_disk.init.id

  network_interface {
    network_name   = var.network_name
    wait_for_lease = true
  }

  disk {
    volume_id = libvirt_volume.os_disk.id
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type        = "vnc"
    listen_type = "address"
    autoport    = true
  }
}
