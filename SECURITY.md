# Security Policy

## 🔒 Supported Versions

This repository contains infrastructure-as-code and dotfiles for personal workstation setup. Security patches and updates are actively maintained on the following branches:

| Branch / Platform | Supported | Notes |
| :--- | :--- | :--- |
| **`master`** | ✅ Active | Linux workstations (Ubuntu, Debian, Arch, Fedora) |
| **`mac-master`** | ✅ Active | macOS (Apple Silicon & Intel) |

---

## 🛡️ Secret Management & Sensitive Data

### 1. Ansible Vault Policies
- **Encrypted Storage**: All sensitive credentials (API tokens, private SSH keys, webhooks, cloud credentials) **must** be encrypted with AES-256 via Ansible Vault and stored exclusively in [`vars/vault.yml`](vars/vault.yml).
- **External Password Storage**: The vault password file must **never** reside inside this repository. It is configured to live outside the workspace at:
  ```text
  $HOME/.ansible/vault/vault.yml
  ```
- **Local Credential Placement**: Decrypted secrets must never be staged into the repository filesystem (e.g., `files/keys/`). They are deployed directly to their destination with minimal Unix permissions:
  - `~/.ssh/` (`0700`)
  - Private SSH keys (`0600`)
  - Public SSH keys (`0644`)
  - `~/.config/gh/hosts.yml` (`0600`)

### 2. Environment Files (`.env`)
- `.env` files are strictly ignored via [`.gitignore`](.gitignore).
- Only sanitized `.env.example` templates with placeholder values may be checked into Git.

### 3. Automated Scanning in CI
- Every push and pull request runs automated [Gitleaks](https://github.com/gitleaks/gitleaks) secret scanning via GitHub Actions ([`.github/workflows/ci.yml`](.github/workflows/ci.yml)) to prevent accidental credential leakage.

---

## 🚨 Reporting a Vulnerability

If you discover a security vulnerability or accidental credential exposure in this repository:

1. **Do not open a public GitHub issue.**
2. Report the vulnerability privately via **GitHub Private Vulnerability Reporting** on the repository's **Security** tab, or email the maintainer directly at `aravindr597@gmail.com`.
3. Include detailed steps to reproduce the issue and any relevant context.
4. Vulnerabilities will be acknowledged within 48 hours and resolved promptly.
