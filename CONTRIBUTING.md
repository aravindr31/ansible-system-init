# Contributing Guide

Thank you for your interest in contributing to `ansible-system-init`! 

To keep the repository clean, secure, and compatible with our target environments, please follow these guidelines.

---

## 🌿 Branching Strategy

This repository maintains separate branches for different operating systems:

- **`mac-master`**: Dedicated solely to **macOS** workstations (Homebrew, macOS fonts, Casks, Apple Silicon/Intel).
- **`master`**: Dedicated solely to **Linux** workstations (Pacman/APT/Dnf, Linux XDG font paths, system packages).

> [!WARNING]
> **Never merge `mac-master` into `master` or vice-versa.**
> Changes meant for macOS must be committed strictly to `mac-master` or PRs branched off `mac-master`.

---

## 🛠️ Development & Testing Workflow

### 1. Creating a Branch
Create a new feature branch from `mac-master`:
```bash
git checkout mac-master
git pull origin mac-master
git checkout -b feature/my-cool-improvement
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

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification to keep Git history clear and traceable:

- `feat(...)`: A new feature, role, or package addition.
- `fix(...)`: A bug fix (e.g., path resolution, privilege error, typo).
- `refactor(...)`: Code restructuring without changing behavior (e.g., modularizing tasks).
- `security(...)`: Security enhancements, permission tightening, or credential handling.
- `docs(...)`: Documentation updates (`README.md`, `SECURITY.md`, etc.).
- `chore(...)`: Routine maintenance, lockfiles, dotfile tweaks, or CI workflow changes.

**Example commit message:**
```text
feat(packages): add ripgrep and fd-find to brew packages
```

---

## 🔒 Security Requirements for Contributions

1. **No Plaintext Secrets**: Never commit API keys, personal tokens, private SSH keys, or unencrypted `.env` files.
2. **Ansible Vault**: All credentials must be placed in `vars/vault.yml` using `ansible-vault`.
3. **Idempotency**: All new Ansible tasks must be idempotent (running them twice should produce `ok` and no unwanted changes).
4. **macOS Paths**: Always use `~/Library/Fonts` for fonts, `/opt/homebrew` & `/usr/local` dynamic checks, and `{{ ansible_user_dir }}` instead of hardcoded home paths.

---

## 📬 Submitting a Pull Request

1. Push your branch to GitHub:
   ```bash
   git push origin feature/my-cool-improvement
   ```
2. Open a Pull Request targeting the **`mac-master`** branch.
3. Verify that all automated GitHub Actions checks (Gitleaks, YAML lint, Ansible syntax check) pass successfully.
4. Describe the changes and the motivation behind them in your PR description.
