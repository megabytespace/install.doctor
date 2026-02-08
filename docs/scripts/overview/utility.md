---
title: Utility Scripts Overview
description: Read about how you can invoke special scripts provided by the Install Doctor repository by leveraging curl. These scripts include features like fully automating the provisioning process and setting up SSO-based SSH certificates for improved security.
sidebar_label: Utility Scripts
slug: /scripts/utility
---

Install Doctor provides several utility scripts that can be run independently via `curl` one-liners. These scripts are housed in the `scripts/` folder at the repository root.

## Script Summary

| Script | Short URL | Purpose |
|---|---|---|
| `scripts/provision.sh` | `https://install.doctor/start` | Full provisioning: installs Homebrew, system deps, Chezmoi, and applies all configurations |
| `scripts/homebrew.sh` | `https://install.doctor/brew` | Standalone Homebrew installer for macOS and Linux |
| `scripts/cloudflared-ssh.sh` | `https://install.doctor/ssh` | Sets up CloudFlare Teams SSO-based SSH with short-lived certificates |
| `start.sh` | (used internally) | Bootstrap: installs Task runner and basic dependencies before `provision.sh` |

## Kickstart Script

The `scripts/provision.sh` script is the main entry point for Install Doctor. It orchestrates the entire provisioning process:

```shell
bash <(curl -sSL https://install.doctor/start)
```

You can customize the provisioning with environment variables:

```shell
# Headless with custom software group and fork
export HEADLESS_INSTALL=true
export SOFTWARE_GROUP=Standard
export START_REPO=YourGitHubUsername
export SUDO_PASSWORD=YourPassword
bash <(curl -sSL https://install.doctor/start)
```

| Variable | Default | Description |
|---|---|---|
| `HEADLESS_INSTALL` | `false` | Skip all interactive prompts |
| `SOFTWARE_GROUP` | (prompted) | Software group: `Full`, `Standard`, or `Minimal` |
| `START_REPO` | `megabyte-labs` | GitHub username/org for the Install Doctor fork |
| `SUDO_PASSWORD` | (prompted) | Sudo password for non-interactive installs |
| `AGE_PASSWORD` | (prompted) | Password for decrypting Age-encrypted secrets |

## Homebrew Install Script

A standalone helper that installs Homebrew on macOS or Linux:

```shell
bash <(curl -sSL https://install.doctor/brew)
```

This is useful if you only want Homebrew without the full provisioning process. On macOS, it also ensures Xcode Command Line Tools are installed first.

## CloudFlare SSO SSH Script

Automates connecting devices to CloudFlare Teams for SSO-protected SSH access using short-lived certificates:

```shell
bash <(curl -sSL https://install.doctor/ssh)
```

This script:
1. Installs `cloudflared` if not already present
2. Configures the SSH client to proxy connections through CloudFlare
3. Sets up short-lived certificates that rotate automatically
4. Authenticates via your SSO provider (Google, GitHub, etc.)

**Prerequisite:** You must have a CloudFlare Teams account with an access policy configured for SSH. See the [CloudFlare integration docs](/docs/integrations/cloudflare) for setup details.
