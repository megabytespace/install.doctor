---
title: Environment Requirements
description: Learn how to install bash and curl on Linux machines which are environment requirements for running the Install Doctor quick start one-liner script.
sidebar_label: Requirements
slug: /getting-started/requirements
---
Install Doctor has a minimal set of requirements since it is, by nature, a batteries-included provisioning script / framework. However, on some devices there may be some initial legwork required.

## Linux

On Linux, you need `bash` and `curl` installed. These are required since they are utilized by the one-line kickstarter script:

```shell
bash <(curl -sSL https://install.doctor/start)
```

### Arch Linux

```shell
pacman -Syu bash curl
```

### CentOS / Fedora

```shell
sudo dnf install -y bash curl
```

### Debian / Ubuntu

```shell
sudo apt-get install -y bash curl
```

## macOS

### macFUSE Kernel Extensions

[macFUSE](https://osxfuse.github.io/) requires kernel extensions which are not allowed by default. macFUSE is required for mounting various data sources as volumes (i.e. allowing you to mount an S3 as a disk). Before provisioning, enable kernel extensions by booting into the recovery environment. You can enable kernel extensions by:

1. Shut down system
2. Press and hold the Touch ID or power button to launch the Startup Security Utility
3. Select "Options"
4. On the top menu bar, select, "Startup Security Utility"
5. In the Startup Security Utility, enable kernel extensions from the Security Policy button
6. Reboot into the main environment
7. Open the System Settings
8. Click on Privacy & Security
9. Enable relevant System Extensions by clicking on "Enable System Extensions..." (Note: If you enable kernel extensions before installing macFUSE, then the option to enable the extensions will not be available yet. You can either manually install macFUSE before running the provisioning process or revisit the settings page and enable them after the kickstart script installs macFUSE)

## Qubes

To provision Qubes, it is important that you begin the provisioning process from a `dom0` terminal session if you want to utilize the one-line kickstarter script:

```shell
qvm-run --pass-io sys-firewall "curl -sSL https://install.doctor/qubes" > ~/setup.sh && bash ~/setup.sh
```

## Windows

The Windows 11 requires elevated administrator privileges so when you first run the one-line setup script, you should preferrably run it from an Administrator PowerShell terminal window.
