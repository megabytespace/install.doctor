---
title: Environment Requirements
description: Learn how to install bash and curl on Linux machines which are environment requirements for running the Install Doctor quick start one-liner script.
sidebar_label: Requirements
slug: /getting-started/requirements
---
Install Doctor is a batteries-included provisioning framework with minimal prerequisites. The bootstrap script handles installing everything else automatically. However, on some platforms there may be initial legwork required.

## Requirements Summary

| Platform | Prerequisites | Install Command | Notes |
|---|---|---|---|
| macOS (Ventura+) | Xcode CLI Tools (auto-prompted) | `bash <(curl -sSL https://install.doctor/start)` | Grant [Full Disk Access](/docs/terminal/full-disk-access) for full functionality |
| Ubuntu / Debian | `bash`, `curl` (pre-installed) | `bash <(curl -sSL https://install.doctor/start)` | Sudo privileges required |
| Fedora / CentOS | `bash`, `curl` (pre-installed) | `bash <(curl -sSL https://install.doctor/start)` | Sudo privileges required |
| Arch Linux | `bash`, `curl` | `bash <(curl -sSL https://install.doctor/start)` | Install with `pacman -Syu --noconfirm bash curl` |
| Alpine | `bash`, `curl` | `bash <(curl -sSL https://install.doctor/start)` | Install with `apk add bash curl` |
| openSUSE | `bash`, `curl` (pre-installed) | `bash <(curl -sSL https://install.doctor/start)` | Sudo privileges required |
| Windows 11 | Administrator PowerShell | `iex ((New-Object System.Net.WebClient).DownloadString('https://install.doctor/windows'))` | Run as Administrator |
| Qubes OS | dom0 terminal access | See [Qubes docs](/docs/advanced/qubes) | Must run from dom0 |

## Hardware Requirements

| Resource | Minimum | Recommended |
|---|---|---|
| RAM | 4 GB | 8+ GB |
| Disk Space | 20 GB free | 50+ GB free (Full software group) |
| Internet | Required for all installs | Broadband for faster provisioning |
| CPU | Any x86_64 or ARM64 | Multi-core for faster compilation |

## Linux

On Linux, you need `bash` and `curl` installed. Most distributions ship with both pre-installed. If not:

```shell
# Arch Linux
sudo pacman -Syu --noconfirm bash curl

# CentOS / Fedora
sudo dnf install -y bash curl

# Debian / Ubuntu
sudo apt-get install -y bash curl

# Alpine
apk add bash curl

# openSUSE
sudo zypper install -y bash curl
```

Then run the kickstart script:

```shell
bash <(curl -sSL https://install.doctor/start)
```

## macOS

### Xcode Command Line Tools

The Xcode Command Line Tools are automatically prompted for installation when the provisioning script runs. You can pre-install them with:

```shell
xcode-select --install
```

If you have the full Xcode app installed, accept the license first:

```shell
sudo xcodebuild -license accept
```

### Full Disk Access

For full functionality (modifying system preferences, accessing protected directories), grant Full Disk Access to your terminal app. See the [Full Disk Access guide](/docs/terminal/full-disk-access) for step-by-step instructions.

### macFUSE Kernel Extensions (Optional)

[macFUSE](https://osxfuse.github.io/) enables mounting remote data sources as local volumes (e.g., S3 buckets as disks). It requires kernel extensions which must be explicitly enabled on Apple Silicon Macs:

1. Shut down system
2. Press and hold the Touch ID or power button to launch Startup Security Utility
3. Select "Options"
4. On the top menu bar, select "Startup Security Utility"
5. Enable kernel extensions from the Security Policy button
6. Reboot into the main environment
7. Open System Settings > Privacy & Security
8. Click "Enable System Extensions..."

> **Note:** If you enable kernel extensions before installing macFUSE, the option to enable extensions will not be available yet. Revisit this step after provisioning installs macFUSE.

## Qubes

Begin the provisioning process from a **dom0** terminal session:

```shell
qvm-run --pass-io sys-firewall "curl -sSL https://install.doctor/qubes" > ~/setup.sh && bash ~/setup.sh
```

See the [Qubes documentation](/docs/advanced/qubes) for full details on template VMs, AppVM provisioning, and customization.

## Windows

Windows 11 requires elevated administrator privileges. Open an **Administrator PowerShell** terminal (right-click PowerShell > "Run as Administrator") and run:

```powershell
iex ((New-Object System.Net.WebClient).DownloadString('https://install.doctor/windows'))
```

The Windows provisioning process uses [Chocolatey](https://chocolatey.org/), [Scoop](https://scoop.sh/), and [winget](https://learn.microsoft.com/en-us/windows/package-manager/winget/) for package management.
