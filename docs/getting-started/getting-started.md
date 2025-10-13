---
title: Getting Started
description: Find out how to get started with Install Doctor by running a one-liner that will transform your device into the ultimate productivity machine.
sidebar_label: Getting Started
slug: /getting-started
---

Install Doctor is designed to be incredibly easy to use. It can provision your entire operating system with a one-liner. It supports the latest x64 releases of Archlinux, CentOS, Debian, Fedora, macOS, Qubes, and Windows. It can also be adapted to run on other operating systems (pull requests encouraged).

On macOS/Linux, the only requirements are that `bash` and `curl` are installed.

## Run Install Doctor

### macOS/Linux

```shell
bash <(curl -sSL https://install.doctor/start)
```

### Windows

On Windows, you can run the following from an administrator PowerShell terminal:

```powershell
iex ((New-Object System.Net.WebClient).DownloadString('https://install.doctor/windows'))
```

### Qubes

The following one-liner should be run from Qubes dom0:

```shell
qvm-run --pass-io sys-firewall "curl -sSL https://install.doctor/qubes" > ~/setup.sh && bash ~/setup.sh
```

## Guided Terminal Prompts

The one-liner installation methods above will interactively prompt for a few details if they are not provided via environment variables or as Chezmoi-housed secrets (see the [Integrating Secrets](/docs/customization/secrets) page for more details). These prompts will ask you for information like:

* The type of installation (i.e. a minimal set of software or all the software Install Doctor supports - see the [Customization Overview](/docs/customization) for more details)
* Your name / e-mail address (to pre-populate things like the Git configuration)
