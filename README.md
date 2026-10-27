# Ansible Linux System Initialization (`ansible-system-init`)

Automated, declarative workstation provisioning and dotfiles management for **Linux** systems (Ubuntu, Debian, Arch Linux, Fedora, and WSL) powered by Ansible.

---

## 📋 Features

- 🐧 **Multi-Distribution Compatibility**:
  - **Debian / Ubuntu**: Native `apt` batch provisioning and dependency management.
  - **Arch Linux / Manjaro**: Native `pacman` database refresh and batch package installation.
  - **Fedora / RedHat**: Native `dnf` package management.
  - **WSL (Windows Subsystem for Linux)**: Automatically detects WSL and skips non-headless/display hooks.
- 📦 **Targeted Package Management**:
  - **Install** (`--tags install`): Batch installs core CLI and distro-specific tools.
  - **Uninstall** (`--tags uninstall`): Removes packages specified in absent lists.
  - **Cleanup** (`--tags cleanup`): Runs `autoremove` / cache clean for your distro's package manager.
- 🔐 **Hardened Vault & Secrets**:
  - Encrypted AES-256 secrets isolated in `vars/vault.yml`.
  - Vault password resides outside the repository (`$HOME/.ansible/vault/vault.yml`).
  - SSH keys and tokens written directly to `~/.ssh/` and `~/.config/gh/` with strict Unix permissions (`0700`/`0600`).
- ⚡ **Modular & Tagged**: Run individual roles or tasks in isolation without running the entire playbook.
- 🎨 **Dotfiles & Fonts**: Configures ZSH (Oh-My-Zsh), Neovim, Kitty, Alacritty, Tmux, Git, SSH, and Linux font caching (`fc-cache`).
- 🛡️ **CI & Secret Scanning**: Built-in GitHub Actions workflow running Gitleaks, YAML linting, and Ansible syntax verification on Ubuntu.

---

## 🚀 Prerequisites

### 1. Install Git & Ansible on Linux

#### Ubuntu / Debian:
```bash
sudo apt update && sudo apt install -y git python3 python3-pip ansible
```

#### Arch Linux:
```bash
sudo pacman -Syu --noconfirm git python ansible
```

#### Fedora:
```bash
sudo dnf install -y git python3 ansible
```

### 2. Configure Ansible Vault Password
The playbook expects your vault password to reside outside the repository as defined in [`ansible.cfg`](./ansible.cfg):
```bash
mkdir -p "$HOME/.ansible/vault"
echo "your_vault_password" > "$HOME/.ansible/vault/vault.yml"
chmod 600 "$HOME/.ansible/vault/vault.yml"
```

---

## 💻 Usage & Targeted Commands

### Full Provisioning
Runs the entire playbook (packages, fonts, and all active roles):
```bash
ansible-playbook main.yml --ask-become-pass
```

### Targeted Execution
Use Ansible tags to run only specific operations:

| Task / Target | Command | Description |
| :--- | :--- | :--- |
| **Install Packages** | `ansible-playbook main.yml --tags install --ask-become-pass` | Installs distro & general packages |
| **Uninstall Packages** | `ansible-playbook main.yml --tags uninstall --ask-become-pass` | Removes packages in `*_packages_absent` |
| **Package Cleanup** | `ansible-playbook main.yml --tags cleanup --ask-become-pass` | Runs `autoremove` & cleans package cache |
| **All Package Tasks** | `ansible-playbook main.yml --tags packages --ask-become-pass` | Runs install, uninstall, and cleanup |
| **All Roles Only** | `ansible-playbook main.yml --tags roles` | Runs all active configuration roles (no sudo needed) |
| **Specific Role** | `ansible-playbook main.yml --tags zsh` | Configures only ZSH / Oh-My-Zsh |
| **Specific Role** | `ansible-playbook main.yml --tags kitty` | Configures only Kitty terminal |
| **Specific Role** | `ansible-playbook main.yml --tags ssh` | Deploys only SSH keys and configs |

### Dry Run Mode
Test execution without applying any changes:
```bash
ansible-playbook main.yml --check
```

---

## ⚙️ Configuration

### 1. General Settings (`vars/main.yml`)
Contains user variables, Git profile, and role selection:
```yaml
default_user: "aravind"
default_roles:
  - kitty
  - docker-compose
  - gh
  - nvim
  - nvm
  - ssh
  - terraform
  - tmux
  - git
  - zsh
```

### 2. Package Lists (`vars/packages.yml`)
- `general_packages`: Core packages installed across all Linux distributions.
- `debian_packages`: Packages installed only on Debian/Ubuntu systems.
- `arch_packages`: Packages installed only on Arch Linux/Manjaro systems.
- `redhat_packages`: Packages installed only on Fedora/RHEL systems.
- Absent lists: Specify packages to remove with `--tags uninstall`.

### 3. Encrypted Secrets (`vars/vault.yml`)
Stores encrypted variables for Discord webhooks, GitHub tokens, and SSH keys.

To edit encrypted secrets:
```bash
ansible-vault edit vars/vault.yml
```

---

## 📁 Repository Structure

```text
├── ansible.cfg            # Ansible runtime configuration & vault password path
├── main.yml               # Primary playbook entrypoint
├── requirements.yml       # External Ansible Galaxy collections / roles
├── .yamllint.yml          # YAML formatting and lint rules
├── .gitignore             # Keeps local keys, .env, and undo caches untracked
├── .github/workflows/     # CI pipeline (Gitleaks, yamllint, syntax-check on Ubuntu)
├── vars/
│   ├── main.yml           # Non-sensitive variables & role toggles
│   ├── packages.yml       # Multi-distro package definitions & absent lists
│   └── vault.yml          # Encrypted Ansible Vault credentials
├── tasks/
│   └── package_install.yml# Multi-distro package installer, uninstall, and cleanup
├── pre_tasks/             # Folder creation, whoami, WSL check, font caching
├── handlers/              # Event handlers (Discord completion notifier)
├── files/                 # Dotfiles and static configuration files
├── templates/             # Jinja2 templates (SSH config, GitHub CLI hosts)
└── roles/                 # Modular roles (zsh, nvim, tmux, kitty, ssh, terraform, etc.)
```
