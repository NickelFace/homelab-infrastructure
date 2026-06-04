# homelab-infrastructure

![Terraform](https://img.shields.io/badge/Terraform-1.7+-7B42BC?logo=terraform&logoColor=white)
![Ansible](https://img.shields.io/badge/Ansible-2.15+-EE0000?logo=ansible&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)
![KVM](https://img.shields.io/badge/KVM-libvirt-F05032?logo=linux&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-green)

Infrastructure-as-Code for a self-hosted home lab running on KVM/libvirt (Ubuntu 26.04).  
Manages VMs, services, and networking through Terraform, Ansible, and Docker Compose.

## Stack

| Layer | Tool | Purpose |
|---|---|---|
| Provisioning | Terraform + libvirt provider | VM lifecycle on KVM |
| Configuration | Ansible | OS hardening, service setup |
| Services | Docker Compose | Containerised workloads |
| Networking | ZeroTier | Overlay VPN for remote access |

## Services Running

| Service | Role |
|---|---|
| Samba AD DC | Active Directory domain controller |
| Postfix + Dovecot | SMTP/IMAP mail stack |
| Nginx | Reverse proxy with TLS termination |
| Prometheus + Grafana | Metrics and dashboards |
| ZeroTier | Site-to-site and remote access VPN |
| NFS | Network storage over LVM volumes |

## Repository Layout

```
.
├── terraform/
│   ├── modules/
│   │   ├── vm/          # KVM virtual machine module
│   │   └── network/     # libvirt network definitions
│   └── environments/
│       ├── prod/        # Production VMs
│       └── dev/         # Dev/lab VMs
├── ansible/
│   ├── inventory/       # Host definitions
│   ├── playbooks/       # Top-level plays
│   └── roles/
│       ├── common/      # Base hardening for all hosts
│       ├── samba_ad/    # Samba Active Directory DC
│       ├── postfix_dovecot/  # Mail stack
│       ├── nginx/       # Reverse proxy
│       └── zerotier/    # ZeroTier node setup
├── docker/
│   ├── nginx-proxy/     # Nginx + Certbot Compose stack
│   ├── monitoring/      # Prometheus + Grafana + Alertmanager
│   └── mail/            # Postfix + Dovecot (containerised variant)
└── docs/
    └── architecture.md  # Network diagram and design notes
```

## Quick Start

```bash
# 1. Clone
git clone https://github.com/NickelFace/homelab-infrastructure
cd homelab-infrastructure

# 2. Provision a dev VM
cd terraform/environments/dev
cp terraform.tfvars.example terraform.tfvars   # fill in your values
terraform init && terraform apply

# 3. Configure it
cd ../../ansible
ansible-playbook -i inventory/hosts.yml playbooks/site.yml
```

## Requirements

- Terraform >= 1.7
- Ansible >= 2.15
- KVM/libvirt on the host (`apt install qemu-kvm libvirt-daemon-system`)
- Python 3.10+ for Ansible

## Certifications context

Built as a hands-on companion to:
- ✅ LPIC-2 (202-450) — Linux networking and services
- 🔄 Cisco CCNA 200-301 — in progress
- 🔜 AWS SAA-C03 — planned
