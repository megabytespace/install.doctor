<!-- This README has been generated from the file(s) ".config/docs/blueprint-readme-misc.md" --><div align="center">
  <center>
    <a href="https://github.com/megabyte-labs/install.doctor">
      <img width="320" alt="Install Doctor logo" src="https://gitlab.com/megabyte-labs/install.doctor/-/raw/master/docs/logo-full.png" />
    </a>
  </center>
</div>
<div align="center">
  <center><h1 align="center"><i></i>Install Doctor - Cross-Platform Desktop Provisioning<i></i></h1></center>
  <center><h4 style="color: #18c3d1;">Maintained by <a href="https://megabyte.space" target="_blank">Megabyte Labs</a></h4><i></i></center>
</div>

<div align="center">
  <a href="https://megabyte.space" title="Megabyte Labs homepage" target="_blank">
    <img alt="Homepage" src="https://img.shields.io/website?down_color=%23FF4136&down_message=Down&label=Homepage&logo=home-assistant&logoColor=white&up_color=%232ECC40&up_message=Up&url=https%3A%2F%2Fmegabyte.space&style=for-the-badge" />
  </a>
  <a href="https://github.com/megabyte-labs/install.doctor/blob/master/docs/CONTRIBUTING.md" title="Learn about contributing" target="_blank">
    <img alt="Contributing" src="https://img.shields.io/badge/Contributing-Guide-0074D9?logo=github-sponsors&logoColor=white&style=for-the-badge" />
  </a>
  <a href="https://app.slack.com/client/T01ABCG4NK1/C01NN74H0LW/details/" title="Chat with us on Slack" target="_blank">
    <img alt="Slack" src="https://img.shields.io/badge/Slack-Chat-e01e5a?logo=slack&logoColor=white&style=for-the-badge" />
  </a>
  <a href="https://app.element.io/#/room/#install.doctor:matrix.org" title="Chat with the community via Matrix.org" target="_blank">
    <img alt="Matrix" src="https://img.shields.io/matrix/install.doctor:matrix.org?logo=matrix&logoColor=white&style=for-the-badge" />
  </a>
  <a href="https://github.com/megabyte-labs/install.doctor" title="GitHub mirror" target="_blank">
    <img alt="GitHub" src="https://img.shields.io/badge/Mirror-GitHub-333333?logo=github&style=for-the-badge" />
  </a>
  <a href="https://gitlab.com/megabyte-labs/install.doctor" title="GitLab repository" target="_blank">
    <img alt="GitLab" src="https://img.shields.io/badge/Repo-GitLab-fc6d26?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgAQMAAABJtOi3AAAABlBMVEUAAAD///+l2Z/dAAAAAXRSTlMAQObYZgAAAHJJREFUCNdNxKENwzAQQNEfWU1ZPUF1cxR5lYxQqQMkLEsUdIxCM7PMkMgLGB6wopxkYvAeI0xdHkqXgCLL0Beiqy2CmUIdeYs+WioqVF9C6/RlZvblRNZD8etRuKe843KKkBPw2azX13r+rdvPctEaFi4NVzAN2FhJMQAAAABJRU5ErkJggg==&style=for-the-badge" />
  </a>
</div>

> <br/><h4 align="center"><strong>A performant, cross-platform desktop provisioning system combining application settings, themes, and automated software installation.</strong></h4><br/>

<a href="#table-of-contents" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
  - [Headless Installation](#headless-installation)
  - [Using a Fork](#using-a-fork)
  - [Quick Start Notes](#quick-start-notes)
- [Environment Variables](#environment-variables)
- [Architecture](#architecture)
  - [Provisioning Flow](#provisioning-flow)
  - [Dependencies](#dependencies)
- [Chezmoi-Based](#chezmoi-based)
- [Security Focused](#security-focused)
- [Cross-Platform](#cross-platform)
  - [Supported Platforms](#supported-platforms)
  - [Custom Software Provisioning System](#custom-software-provisioning-system)
  - [Beautiful Anywhere](#beautiful-anywhere)
  - [Qubes Support](#qubes-support)
- [Gas Station](#gas-station)
- [Chezmoi](#chezmoi)
  - [Resetting Chezmoi](#resetting-chezmoi)
- [Contributing](#contributing)
  - [Affiliates](#affiliates)
- [License](#license)

<a href="#overview" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Overview

Install Doctor is a cross-platform development environment provisioning system that combines application settings, theme files, and a performant software installer written with [ZX](https://github.com/google/zx). It uses [Chezmoi](https://github.com/twpayne/chezmoi) to manage dotfiles and apply configuration changes across systems.

The project is built around the philosophy that you should be able to reformat your computer and fully restore it by storing stateful data in an encrypted S3 bucket and automating desktop configuration. It supports macOS, most Linux distributions, and has Windows support on the roadmap.

Install Doctor is intended for:

1. **Power users** who want to maximize efficiency by incorporating [popular open-source tools](https://stars.megabyte.space) into their stack
2. **Distro hoppers** who want consistent tooling across macOS, Windows, and Linux
3. **Automation enthusiasts** who want to reformat and restore their systems with minimal effort
4. **CLI users** who want a portable, reproducible terminal environment
5. **Security-conscious users** who regularly reformat and need fast, reliable reprovisioning

<a href="#quick-start" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Quick Start

To provision your workstation with interactive prompts:

```bash
bash <(curl -sSL https://install.doctor/start)
```

### Headless Installation

To run completely unattended with no interactive prompts (all prompts auto-proceed with defaults after a 30-second timeout):

```bash
HEADLESS_INSTALL=true bash <(curl -sSL https://install.doctor/start)
```

For full control over the headless installation:

```bash
HEADLESS_INSTALL=true \
  SOFTWARE_GROUP=Full \
  SUDO_PASSWORD=your_password \
  FULL_NAME="Your Name" \
  PRIMARY_EMAIL="you@example.com" \
  bash <(curl -sSL https://install.doctor/start)
```

### Using a Fork

If you fork this repository and would like to use your fork as the source, set the `START_REPO` environment variable:

```bash
# GitHub shorthand (user/repo)
START_REPO=my-gh-user/my-fork-name bash <(curl -sSL https://install.doctor/start)

# Full git URL
START_REPO=git@gitlab.com:my-user/install.doctor.git bash <(curl -sSL https://install.doctor/start)

# GitHub username only (assumes repo name is install.doctor)
START_REPO=my-gh-user bash <(curl -sSL https://install.doctor/start)
```

### Quick Start Notes

- Tested on latest versions of Archlinux, CentOS, Debian, Fedora, macOS, and Ubuntu
- The quick start script is the preferred method of provisioning
- All interactive prompts have timeouts and will auto-proceed with sensible defaults
- _Windows support is on the roadmap_

<a href="#environment-variables" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Environment Variables

The following environment variables can be used to customize the provisioning process:

| Variable | Description | Default |
|---|---|---|
| `START_REPO` (or `REPO`) | Git repository URL or GitHub `user/repo` shorthand | `megabyte-labs/install.doctor` |
| `HEADLESS_INSTALL` | Skip all interactive prompts and use defaults | unset |
| `SOFTWARE_GROUP` | Software group to install: `Basic`, `Server`, `Standard`, or `Full` | `Full` |
| `SUDO_PASSWORD` | Sudo password for automated passwordless sudo setup | unset (prompts with 30s timeout) |
| `CI` or `TEST_INSTALL` | Enable CI mode with predefined test defaults | unset |
| `NO_RESTART` | Prevent automatic reboots after system updates | unset |
| `FULL_NAME` | User's full name for git config and other tools | unset |
| `PRIMARY_EMAIL` | User's primary email address | unset |
| `AGE_PASSWORD` | Passphrase for decrypting Age-encrypted secrets | unset |
| `DEBUG_MODE` (or `DEBUG`) | Enable verbose logging and debug output | unset |
| `KEEP_GOING` | Continue provisioning even if errors occur | unset |
| `ANSIBLE_PROVISION_VM` | **Qubes only**: Name of the VM used for provisioning | `provision` |
| `NO_INSTALL_HOMEBREW` | Skip Homebrew installation entirely | unset |

For a full list of variables, see the [Customization](https://install.doctor/docs/customization) and [Secrets](https://install.doctor/docs/customization/secrets) documentation.

<a href="#architecture" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Architecture

### Provisioning Flow

```
bash <(curl -sSL https://install.doctor/start)
  |
  v
scripts/provision.sh (main orchestrator)
  |-- ensureBasicDeps()     - Install system packages (curl, git, etc.)
  |-- ensureHomebrew()      - Install and configure Homebrew
  |-- setupPasswordlessSudo() - Temporary passwordless sudo (with 30s timeout)
  |-- cloneChezmoiSourceRepo() - Clone/update the Install Doctor repository
  |-- ensureHomebrewDeps()  - Install Chezmoi, Gum, Glow, Node.js, ZX
  |-- initChezmoiAndPrompt() - Initialize Chezmoi configuration
  |-- runChezmoi()          - Apply dotfiles and run provisioning scripts
  |     |
  |     v
  |   home/.chezmoiscripts/
  |     |-- run_before_01-prepare.sh      - System preparation
  |     |-- run_before_02-homebrew.sh     - Homebrew setup
  |     |-- run_before_03-decrypt-age-key.sh - Secret decryption
  |     |-- run_before_04-requirements.sh - System requirements
  |     |-- run_before_05-system.sh       - System tweaks
  |     |-- run_after_01-pre-install.sh   - Pre-install tasks
  |     |-- run_after_10-install.sh       - Software installation
  |     |-- run_after_15-chezmoi-system.sh - System-level chezmoi
  |     |-- run_after_20-post-install.sh  - Post-install configuration
  |     |-- run_after_24-cleanup.sh       - Cleanup tasks
  |
  |-- removePasswordlessSudo() - Remove temporary sudo privileges
  |-- handleRequiredReboot()   - Reboot if system updates require it
  v
  Done
```

### Dependencies

The following tools are installed automatically during provisioning:

| Dependency | Required | Description |
|---|---|---|
| Chezmoi | Yes | Dotfile configuration manager |
| Task | Yes | Task runner for parallelization and dependency management |
| ZX / Node.js | Yes | Node.js-based scripting for the software installer |
| Homebrew | Yes | Cross-platform package manager |
| Gum | No | Terminal UI prompt CLI for interactive prompts |
| Glow | No | Markdown renderer for terminal-friendly documentation display |
| Age | No | Encryption tool for Chezmoi secret management |

<a href="#chezmoi-based" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Chezmoi-Based

This project leverages [Chezmoi](https://github.com/twpayne/chezmoi) to provide:

1. **File diffs** that show exactly how files are being changed before applying
2. **Encryption** via [Age](https://github.com/FiloSottile/age) that lets you store private data publicly on GitHub
3. **Template-based configuration** that adapts dotfiles to the current OS, hostname, and user preferences
4. **Interactive prompts** that accept API credentials for services like CloudFlare, GitHub, GitLab, and Slack

<a href="#security-focused" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Security Focused

This software was built with security as a priority, employing technologies like:

- [Firejail](https://github.com/netblue30/firejail) - Application sandboxing
- [Portmaster](https://safing.io/) - Network monitor and firewall
- [Little Snitch](https://www.obdev.at/products/littlesnitch/index.html) - macOS network monitor
- [Qubes OS](https://www.qubes-os.org/) - Security-oriented operating system

Whenever possible, Flatpaks are used as the preferred application type for their sandboxing capabilities. The emphasis on security also drives the emphasis on performance - when you regularly reformat your workstation, fast provisioning is essential.

<a href="#cross-platform" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Cross-Platform

### Supported Platforms

| Platform | Status | Notes |
|---|---|---|
| macOS | Supported | Intel and Apple Silicon (Rosetta 2 auto-installed) |
| Ubuntu / Debian | Supported | Tested on latest LTS releases |
| Fedora / RHEL | Supported | Tested on latest releases |
| CentOS | Supported | Via yum/dnf |
| Archlinux | Supported | Rolling release |
| OpenSUSE | Supported | Via zypper |
| Alpine | Supported | Via apk |
| Qubes OS | In Progress | Dom0 and AppVM provisioning |
| Windows | Roadmap | Planned via WSL |
| FreeBSD | Roadmap | Not yet implemented |

### Custom Software Provisioning System

The project incorporates a custom [ZX](https://github.com/google/zx) script that manages software installation across multiple package managers. It uses the [software.yml](/software.yml) file to determine which package manager to use for each application, preferring the most secure option (e.g., Flatpaks for Linux applications). The installer runs asynchronously where possible for better performance.

### Beautiful Anywhere

A sizable amount of effort went into customizing the popular [Sweet](https://github.com/EliverLara/Sweet) theme across platforms. Custom GRUB2 and Plymouth themes are included for a polished boot experience on Linux.

### Qubes Support

Qubes OS support is in progress, with dom0 provisioning and AppVM configuration being actively developed. See the `home/.chezmoiscripts/qubes/` directory for Qubes-specific provisioning scripts.

<a href="#gas-station" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Gas Station

This project evolved from [Gas Station](https://gitlab.com/megabyte-labs/gas-station), an Ansible-based provisioning system with hundreds of roles. Some Gas Station Ansible roles are still referenced in [`software.yml`](/software.yml) as a fallback installation method. The installer tries lighter methods (Homebrew, Flatpak, etc.) before resorting to Ansible.

<a href="#chezmoi" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Chezmoi

This project uses Chezmoi to orchestrate the provisioning process. After the quick start script installs dependencies (including Chezmoi), it hands control to Chezmoi which manages dotfile application and runs provisioning scripts.

To customize this project, refer to the [Chezmoi documentation](https://www.chezmoi.io/) for details on file naming conventions (`dot_`, `run_`, `encrypted_`, etc.).

### Resetting Chezmoi

If there is an error during provisioning or your changes are not being applied, clear Chezmoi's cache and configuration:

```bash
rm -rf ~/.config/chezmoi && rm -rf ~/.cache/chezmoi
```

Then re-run the quick start command to reprovision from scratch.

<a href="#contributing" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/megabyte-labs/install.doctor/issues). If you would like to contribute, please take a look at the [contributing guide](https://github.com/megabyte-labs/install.doctor/blob/master/docs/CONTRIBUTING.md).

<details>
<summary><b>Sponsorship</b></summary>
<br/>
<blockquote>
<br/>
Dear Awesome Person,<br/><br/>
I create open source projects out of love. Although I have a job, shelter, and as much fast food as I can handle, it would still be pretty cool to be appreciated by the community for something I have spent a lot of time and money on. Please consider sponsoring me! Who knows? Maybe I will be able to quit my job and publish open source full time.
<br/><br/>Sincerely,<br/><br/>

**_Brian Zalewski_**<br/><br/>

</blockquote>

<a title="Support us on Open Collective" href="https://opencollective.com/megabytelabs" target="_blank">
  <img alt="Open Collective sponsors" src="https://img.shields.io/opencollective/sponsors/megabytelabs?logo=opencollective&label=OpenCollective&logoColor=white&style=for-the-badge" />
</a>
<a title="Support us on GitHub" href="https://github.com/ProfessorManhattan" target="_blank">
  <img alt="GitHub sponsors" src="https://img.shields.io/github/sponsors/ProfessorManhattan?label=GitHub%20sponsors&logo=github&style=for-the-badge" />
</a>
<a href="https://www.patreon.com/ProfessorManhattan" title="Support us on Patreon" target="_blank">
  <img alt="Patreon" src="https://img.shields.io/badge/Patreon-Support-052d49?logo=patreon&logoColor=white&style=for-the-badge" />
</a>

### Affiliates

Below you will find a list of services we leverage that offer special incentives for signing up for their services through our special links:

<a href="http://eepurl.com/h3aEdX" title="Sign up for $30 in MailChimp credits" target="_blank">
  <img alt="MailChimp" src="https://cdn-images.mailchimp.com/monkey_rewards/grow-business-banner-2.png" />
</a>
<a href="https://www.digitalocean.com/?refcode=751743d45e36&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge">
  <img src="https://web-platforms.sfo2.digitaloceanspaces.com/WWW/Badge%203.svg" alt="DigitalOcean Referral Badge" />
</a>

</details>

<a href="#license" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## License

Copyright (c) 2020-2025 [Megabyte LLC](https://megabyte.space). This project is [MIT](https://gitlab.com/megabyte-labs/install.doctor/-/blob/master/LICENSE) licensed.
