---
title: Security Features
description: Browse through the technical details on the security measures that Install Doctor employs to keep your device safe from potential adversaries.
sidebar_label: Security
slug: /advanced/security
---

Install Doctor takes a defense-in-depth approach to security by layering multiple protection mechanisms across the provisioned system. This page details the security features that are currently implemented and configured during provisioning.

## Antivirus and Malware Detection

### ClamAV

Install Doctor installs and configures [ClamAV](https://www.clamav.net/), the open-source antivirus engine, across all supported platforms. ClamAV provides:

- Real-time file scanning via `clamd`
- Scheduled signature database updates via `freshclam`
- On-demand scanning with `clamscan`

ClamAV is installed via the system package manager (`apt`, `dnf`, `pacman`) on Linux and via Homebrew on macOS.

### Rootkit Detection

[Rkhunter](http://rkhunter.sourceforge.net/) (Rootkit Hunter) is installed on Linux systems to scan for:

- Known rootkits and backdoors
- Suspicious file permission changes
- Hidden files in common locations
- Suspicious kernel modules

### Intrusion Prevention

[fail2ban](https://www.fail2ban.org/) is installed on Linux systems to monitor log files and automatically ban IP addresses that show malicious signs such as repeated failed authentication attempts.

## SSH Hardening

Install Doctor applies hardened SSH configurations during provisioning:

- **Custom SSH port** - The SSH daemon can be configured to listen on a non-standard port (defined in `.chezmoi.yaml.tmpl`)
- **SELinux integration** - On systems with SELinux (Fedora, CentOS, RHEL), the custom SSH port is registered via `semanage` to comply with SELinux policies
- **Key-based authentication** - SSH key generation and import is handled during the provisioning process
- **Service management** - The SSH service is automatically enabled and configured based on the distribution (e.g., `ssh` on Debian/Ubuntu, `sshd` on Fedora/Arch)

## GPG Key Management

Install Doctor configures GPG with security-hardened settings:

- Downloads a hardened `gpg.conf` configuration
- Imports and trusts your GPG key (specified via the `KEYID` environment variable)
- Configures `gpg-agent` with sensible defaults
- Sets appropriate file permissions on `~/.gnupg` (700 for directory, 600 for files)

## Secrets Management

All sensitive data (API keys, tokens, passwords) is encrypted at rest using [Age](https://github.com/FiloSottile/age) encryption and decrypted during provisioning via Chezmoi's built-in decryption support. See the [Secrets documentation](/docs/customization/secrets) for details.

## Application Firewalls

Install Doctor includes support for application-level firewalls:

- **Little Snitch** (macOS) - Network monitor and firewall that alerts you when applications attempt to make network connections
- **OpenSnitch** (Linux) - Application-level firewall inspired by Little Snitch (package defined, active configuration pending)
- **Portmaster** (Linux/Windows) - Privacy-focused application firewall (package defined, configuration pending)

## Network Security

- **Cloudflare WARP** - Encrypted DNS and optional VPN tunneling via Cloudflare's network
- **Tailscale** - Zero-config WireGuard mesh VPN for secure device-to-device communication
- **WireGuard** - Modern VPN protocol with automated NetworkManager profile configuration
- **OpenVPN** - Traditional VPN support with automated profile import from `~/.config/vpn/*.ovpn` files

## Security Philosophy

Install Doctor's security approach prioritizes:

1. **Layered defense** - No single point of failure. Multiple tools cover different threat vectors.
2. **Sensible defaults** - Security features are enabled by default without requiring user configuration.
3. **Non-intrusive** - Security tools run in the background and do not interfere with normal workflow.
4. **Cross-platform consistency** - The same security posture is applied regardless of the operating system.

## Planned Features

The following security features are defined in the software catalog but not yet fully integrated into the provisioning pipeline:

- **Firejail** - Application sandboxing for Linux (profiles pending)
- **AppArmor profiles** - Mandatory access control policies for applications
- **Advanced host-based IDS** - Extended intrusion detection beyond fail2ban
