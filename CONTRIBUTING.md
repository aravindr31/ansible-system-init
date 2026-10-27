# Contributing Guide

Thank you for your interest in contributing to `ansible-system-init`! 

To keep the repository clean, secure, and compatible with our target environments, please follow these guidelines.

---

## 🌿 Branching Strategy

This repository maintains separate branches for different operating systems:

- **`master`**: Dedicated solely to **Linux** workstations (Debian, Ubuntu, Arch Linux, Fedora, WSL).
- **`mac-master`**: Dedicated solely to **macOS** workstations (Homebrew, macOS fonts, Casks, Apple Silicon/Intel).

> [!WARNING]
> **Never merge `master` into `mac-master` or vice-versa.**
> Changes meant for Linux must be committed strictly to `master` or PRs branched off `master`.

---

## 🛠️ Development & Testing Workflow

### 1. Creating a Branch
Create a new feature branch from `master`:
```bash
git checkout master
git pull origin master
git checkout -b feature/linux-improvement
```

### 2. Linting & Syntax Checks
Before submitting your changes, run syntax and linting checks locally:

```bash
# 1. Run YAML linting
yamllint -c .yamllint.yml .

# 2. Run Ansible playbook syntax check
ansible-playbook --syntax-check main.yml
```

### 3. Targeted Dry-Run Testing
Always test your changes in check / dry-run mode first:
```bash
# Test specific role without making changes
ansible-playbook main.yml --tags <role_name> --check

# Test package management without making changes
ansible-playbook main.yml --tags install --check
```

---

## 📝 Commit Conventions

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

- `feat(...)`: A new feature, role, or package addition.
- `fix(...)`: A bug fix (e.g., distro detection, permission error, typo).
- `refactor(...)`: Code restructuring without changing behavior.
- `security(...)`: Security enhancements, permission tightening, or credential handling.
- `docs(...)`: Documentation updates (`README.md`, `SECURITY.md`, etc.).
- `chore(...)`: Routine maintenance, lockfiles, dotfile tweaks, or CI workflow changes.

---

## 🔒 Security Requirements for Contributions

1. **No Plaintext Secrets**: Never commit API keys, personal tokens, private SSH keys, or unencrypted `.env` files.
2. **Ansible Vault**: All credentials must be placed in `vars/vault.yml` using `ansible-vault`.
3. **Idempotency**: All Ansible tasks must be idempotent (running them twice should produce `ok` and no unwanted changes).
4. **Multi-Distro Compatibility**: Always account for package manager differences (`apt`, `pacman`, `dnf`) and avoid hardcoding distro-specific commands directly in tasks.
