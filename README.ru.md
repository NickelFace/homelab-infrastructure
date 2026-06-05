[🇬🇧 English version](README.md)

# homelab-infrastructure

![Terraform](https://img.shields.io/badge/Terraform-1.7+-7B42BC?logo=terraform&logoColor=white)
![Ansible](https://img.shields.io/badge/Ansible-2.15+-EE0000?logo=ansible&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)
![KVM](https://img.shields.io/badge/KVM-libvirt-F05032?logo=linux&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-green)

Инфраструктура как код для домашней лаборатории на базе KVM/libvirt (Ubuntu 26.04).
Управление виртуальными машинами, сервисами и сетью через Terraform, Ansible и Docker Compose.

## Стек

| Слой | Инструмент | Назначение |
|---|---|---|
| Подготовка | Terraform + libvirt provider | Жизненный цикл VM на KVM |
| Конфигурация | Ansible | Hardening ОС, настройка сервисов |
| Сервисы | Docker Compose | Контейнеризованные рабочие нагрузки |
| Сеть | ZeroTier | Overlay VPN для удалённого доступа |

## Запущенные сервисы

| Сервис | Роль |
|---|---|
| Samba AD DC | Контроллер домена Active Directory |
| Postfix + Dovecot | Стек SMTP/IMAP |
| Nginx | Обратный прокси с TLS |
| Prometheus + Grafana | Сбор метрик и дашборды |
| ZeroTier | VPN site-to-site и удалённый доступ |
| NFS | Сетевое хранилище на LVM-томах |

## Структура репозитория

```
.
├── terraform/
│   ├── modules/
│   │   ├── vm/          # модуль KVM-виртуальных машин
│   │   └── network/     # определения libvirt-сетей
│   └── environments/
│       ├── prod/        # продуктивные VM
│       └── dev/         # лабораторные VM
├── ansible/
│   ├── inventory/       # описание хостов
│   ├── playbooks/       # основные плейбуки
│   └── roles/
│       ├── common/      # базовый hardening для всех хостов
│       ├── samba_ad/    # Samba Active Directory DC
│       ├── postfix_dovecot/  # почтовый стек
│       ├── nginx/       # обратный прокси
│       └── zerotier/    # настройка ZeroTier-узла
├── docker/
│   ├── nginx-proxy/     # Nginx + Certbot Compose stack
│   ├── monitoring/      # Prometheus + Grafana + Alertmanager
│   └── mail/            # Postfix + Dovecot (контейнерный вариант)
└── docs/
    └── architecture.md  # схема сети и проектные решения
```

## Быстрый старт

```bash
# 1. Клонировать
git clone https://github.com/NickelFace/homelab-infrastructure
cd homelab-infrastructure

# 2. Поднять dev-машину
cd terraform/environments/dev
cp terraform.tfvars.example terraform.tfvars   # заполни своими значениями
terraform init && terraform apply

# 3. Настроить её
cd ../../ansible
ansible-playbook -i inventory/hosts.yml playbooks/site.yml
```

## Требования

- Terraform >= 1.7
- Ansible >= 2.15
- KVM/libvirt на хосте (`apt install qemu-kvm libvirt-daemon-system`)
- Python 3.10+ для Ansible

## Контекст сертификаций

Создано как практическое дополнение к подготовке:
- ✅ LPIC-2 (202-450) — сетевые сервисы Linux
- 🔄 Cisco CCNA 200-301 — в процессе
- 🔜 AWS SAA-C03 — планируется
