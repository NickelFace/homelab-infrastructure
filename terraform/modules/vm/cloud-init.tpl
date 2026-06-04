#cloud-config
hostname: ${hostname}
manage_etc_hosts: true

users:
  - name: maks
    groups: sudo
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh_authorized_keys:
      - ${ssh_pubkey}

package_update: true
packages:
  - qemu-guest-agent
  - python3

runcmd:
  - systemctl enable --now qemu-guest-agent
