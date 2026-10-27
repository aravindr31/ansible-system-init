# Ansible macOS System Initialization (`ansible-system-init`)

Automated, declarative workstation provisioning and dotfiles management for macOS (Apple Silicon & Intel) powered by Ansible.

---

## 📋 Features

- 🍏 **macOS Native**: Full compatibility with Apple Silicon (`/opt/homebrew`) and Intel (`/usr/local/bin`).
- 🍺 **Auto-Bootstrapped Homebrew**: If Homebrew is not installed on the target Mac, the playbook automatically installs it non-interactively (`NONINTERACTIVE=1`), configures its shell environment in `~/.zprofile`, and injects it into the active execution session.
- 📦 **Declarative Package Management**:
  - Formulae & GUI Casks managed via Homebrew.
  - **On-Demand Auto-Prune** (`--tags prune`): Automatically removes packages deleted from your configuration.
  - **Cleanup Tasks** (`--tags cleanup`): Removes dangling dependencies (`autoremove`) and prunes cache files.
  - **Explicit Uninstall** (`--tags uninstall`): Removes packages specified in absent lists.
- 🔐 **Hardened Vault & Secrets**:
  - Encrypted AES-256 secrets isolated in `vars/vault.yml`.
  - Vault password resides outside the repository (`$HOME/.ansible/vault/vault.yml`).
  - SSH keys and tokens written directly to `~/.ssh/` and `~/.config/gh/` with strict Unix permissions (`0700`/`0600`).
- ⚡ **Modular & Tagged**: Run individual roles or tasks in isolation without having to execute the entire playbook.
- 🎨 **Dotfiles & Tooling**: Configures ZSH (Oh-My-Zsh), Neovim, Kitty, Wezterm, Aerospace, Git, SSH, and fonts.
- 🛡️ **CI & Secret Scanning**: Built-in GitHub Actions workflow running Gitleaks, YAML linting, and Ansible syntax verification.

---

## 🚀 Prerequisites

### 1. Minimal Initial Setup
On a brand new Mac, you only need Xcode Command Line Tools and Ansible:
```bash
# 1. Install Xcode Command Line Tools
xcode-select --install

# 2. Install Ansible (via Homebrew if installed, or via python3 pip)
# If Homebrew is already installed:
brew install ansible

# If starting completely fresh without Homebrew:
python3 -m pip install --user ansible
```
> [!NOTE]
> **Homebrew is automatically installed by the playbook**: If Homebrew is not already installed on your Mac, the playbook will automatically download, install, and configure Homebrew (for Apple Silicon or Intel) during its initial package run.

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
ansible-playbook main.yml
```

### Targeted Execution
Use Ansible tags to run only specific operations:

| Task / Target | Command | Description |
| :--- | :--- | :--- |
| **Install Packages** | `ansible-playbook main.yml --tags install` | Installs Homebrew packages & casks only |
| **Uninstall Packages** | `ansible-playbook main.yml --tags uninstall` | Removes packages listed in `brew_*_absent` |
| **Declarative Prune** | `ansible-playbook main.yml --tags prune` | Uninstalls any top-level package removed from your YAML |
| **Brew Cleanup** | `ansible-playbook main.yml --tags cleanup` | Runs `brew autoremove` and `brew cleanup --prune=all` |
| **All Package Tasks** | `ansible-playbook main.yml --tags packages` | Runs Homebrew install, uninstall, and cleanup |
| **All Roles Only** | `ansible-playbook main.yml --tags roles` | Runs all active configuration roles (skips brew) |
| **Specific Role** | `ansible-playbook main.yml --tags zsh` | Configures only ZSH / Oh-My-Zsh |
| **Specific Role** | `ansible-playbook main.yml --tags kitty` | Configures only Kitty terminal |
| **Specific Role** | `ansible-playbook main.yml --tags ssh` | Deploys only SSH keys and configs |

### Dry Run Mode
Test execution without applying any changes:
```bash
ansible-playbook main.yml --check
```
*(Or set `dry_run: true` in `vars/main.yml`)*.

---

## ⚙️ Configuration

### 1. General Settings (`vars/main.yml`)
Contains user variables, Git profile, and role selection:
```yaml
default_user: "aravind"
default_roles:
  - kitty
  - gh
  - nvim
  - ssh
  - tmux
  - git
  - zsh

update_brew: false   # Set to true to run brew update during package installs
```

### 2. Package Lists (`vars/packages.yml`)
- `brew_packages`: List of CLI formulae to keep installed.
- `brew_cask_packages`: List of GUI applications to keep installed.
- `brew_protected_packages` / `brew_protected_casks`: Software installed manually on your Mac that should **never** be touched by declarative pruning.
- `brew_packages_absent` / `brew_cask_packages_absent`: Software to explicitly uninstall.

### 3. Encrypted Secrets (`vars/vault.yml`)
Stores encrypted variables for:
- Discord notifications webhook
- GitHub personal access token
- SSH private and public keys
- Cloud provider credentials

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
├── .github/workflows/     # CI pipeline (Gitleaks, yamllint, syntax-check)
├── vars/
│   ├── main.yml           # Non-sensitive variables & role toggles
│   ├── packages.yml       # Formulae, casks, protected items, and cleanup flags
│   └── vault.yml          # Encrypted Ansible Vault credentials
├── tasks/
│   └── package_install.yml# Dynamic Homebrew installer, prune, and cleanup
├── pre_tasks/             # Start timers, ensure directories, install fonts
├── post_tasks/            # Execution duration calculator
├── handlers/              # Event handlers (Discord completion notifier)
├── files/                 # Dotfiles and static configuration files
├── templates/             # Jinja2 templates (SSH config, GitHub CLI hosts)
└── roles/                 # Modular roles (zsh, nvim, tmux, kitty, ssh, etc.)
```

---

## 🔒 Security & CI Checks

Every push and pull request triggers [`.github/workflows/ci.yml`](./.github/workflows/ci.yml) to ensure code quality:

1. **Gitleaks Scan**: Audits commits to detect any accidental plaintext API keys, passwords, or private keys.
2. **YAML Linting**: Enforces standard syntax and indentation via `yamllint`.
3. **Ansible Syntax Validation**: Verifies that playbooks and tasks parse cleanly on a macOS runner.

### Adding Vault Password to GitHub Secrets (Optional)
To allow the CI syntax checker to validate the encrypted `vars/vault.yml` against your real vault:
1. Navigate to your GitHub repository: **Settings** ➔ **Secrets and variables** ➔ **Actions**.
2. Click **New repository secret**.
3. Name: `ANSIBLE_VAULT_PASSWORD`.
4. Value: Paste your vault password.

*(If omitted, CI automatically stubs non-sensitive fields so the syntax check still succeeds without errors).*

