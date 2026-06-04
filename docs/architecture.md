# Architecture

## Overview

Single-host homelab running KVM/libvirt on Ubuntu 26.04. All workloads are VMs provisioned by Terraform and configured by Ansible. Containerised services (monitoring, mail variant) run via Docker Compose on the nginx-proxy VM.

ZeroTier provides an encrypted overlay network for remote access without exposing ports to the internet.

---

## Network layout

### KVM bridge network — `192.168.122.0/24`

| VM | Hostname | IP | Role |
|---|---|---|---|
| samba-dc | samba-dc.home.lab | 192.168.122.10 | Samba AD DC, DNS, Kerberos |
| mail | mail.home.lab | 192.168.122.11 | Postfix + Dovecot |
| nginx-proxy | nginx-proxy.home.lab | 192.168.122.12 | Nginx reverse proxy, Prometheus + Grafana |

All VMs are on the default libvirt NAT bridge (`virbr0`). The KVM host performs NAT — VMs reach the internet, internet cannot reach VMs directly.

### ZeroTier overlay — `10.147.x.x/24` (network-specific)

ZeroTier is installed on all VMs. Provides:
- Remote SSH access without port forwarding
- Site-to-site connectivity for future expansion
- Peer-to-peer encrypted tunnels (no traffic through ZeroTier servers after handshake)

---

## Diagram

```mermaid
graph TD
    subgraph KVM Host
        subgraph virbr0 192.168.122.0/24
            DC[samba-dc<br/>192.168.122.10<br/>Samba AD · DNS · Kerberos]
            MAIL[mail<br/>192.168.122.11<br/>Postfix · Dovecot]
            PROXY[nginx-proxy<br/>192.168.122.12<br/>Nginx · Prometheus · Grafana]
        end
    end

    INTERNET((Internet)) -->|NAT| KVM Host
    REMOTE([Remote host<br/>ZeroTier client]) -->|ZeroTier overlay| DC
    REMOTE -->|ZeroTier overlay| MAIL
    REMOTE -->|ZeroTier overlay| PROXY

    DC -->|LDAP auth| MAIL
    DC -->|LDAP auth| PROXY
    PROXY -->|scrape metrics| DC
    PROXY -->|scrape metrics| MAIL
```

---

## Service dependencies

```
nginx-proxy
  └── Prometheus  ──scrapes──►  samba-dc, mail, nginx-proxy (node_exporter)
  └── Grafana     ──reads──►   Prometheus

mail (Postfix + Dovecot)
  └── SASL auth   ──binds──►  samba-dc (LDAP/AD)

samba-dc
  └── DNS         ──resolves── all VMs (home.lab zone)
  └── Kerberos    ──issues──►  krb5 tickets for domain members
```

---

## Storage

| VM | Disk | Notes |
|---|---|---|
| samba-dc | 20 GB qcow2 | AD database, sysvol |
| mail | 40 GB qcow2 | Maildir storage |
| nginx-proxy | 20 GB qcow2 | Docker volumes for Prometheus TSDB, Grafana |

Disk images live in `/var/lib/libvirt/images/` on the KVM host. LVM thin pool is used for efficient snapshots (configured in the Terraform vm module).

---

## Security model

| Control | Implementation |
|---|---|
| SSH hardening | `common` role: key-only auth, root login disabled, fail2ban |
| Firewall | UFW on all VMs: default deny inbound, explicit allowlist per role |
| Remote access | ZeroTier overlay — no public ports open |
| TLS | Certbot (Let's Encrypt) on nginx-proxy for internal services via DNS challenge |
| Secrets | `terraform.tfvars` gitignored; Ansible vault for sensitive vars (planned) |

---

## Terraform module overview

```
terraform/
├── modules/
│   ├── vm/        — qcow2 disk + domain XML + cloud-init config
│   └── network/   — libvirt NAT network definition
└── environments/
    ├── prod/      — calls vm module for each production host
    └── dev/       — single throwaway VM for testing roles
```

Each VM gets a `cloud-init` user-data template (`cloud-init.tpl`) that:
- Creates the `maks` user with SSH key
- Sets hostname
- Runs `apt update` on first boot
