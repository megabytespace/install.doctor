---
title: Tailscale Integration
description: Learn about how Install Doctor integrates Tailscale to provide a WireGuard-powered LAN that is capable of connecting any two devices as long as they are connected to the internet.
sidebar_label: Tailscale
slug: /integrations/tailscale
---

Tailscale creates a WireGuard-based VPN network that connects all your devices to a shared LAN-like network. It is free for up to 100 devices on the Personal plan and is especially useful for connecting devices behind firewalls, NATs, or across different physical networks.

## How It Works

Install Doctor automatically installs Tailscale and connects your device to your mesh VPN when the `TAILSCALE_AUTH_KEY` is provided.

| Step | What Happens |
|---|---|
| 1 | Tailscale is installed via the system package manager or Homebrew |
| 2 | `tailscale up --authkey $TAILSCALE_AUTH_KEY` is run to authenticate |
| 3 | The device joins your Tailscale network and gets a `100.x.y.z` IP address |
| 4 | All your Tailscale devices can now communicate directly |

## Configuration

| Variable | Required | Description |
|---|---|---|
| `TAILSCALE_AUTH_KEY` | Yes | Reusable auth key from the [Tailscale admin dashboard](https://login.tailscale.com/admin/settings/keys) |

### Generating an Auth Key

1. Log in to the [Tailscale admin console](https://login.tailscale.com/admin/settings/keys)
2. Click **"Generate auth key..."**
3. Check the following options:
   - **Reusable** - Allows the same key on multiple devices
   - **Ephemeral** - Devices are automatically removed when they go offline
   - **Pre-approved** - Devices join without manual approval
4. Copy the generated key
5. Store it as an encrypted secret (see [Secrets documentation](/docs/customization/secrets)):

```shell
echo -n "tskey-auth-xxxxxxxxxxxx" | chezmoi encrypt > home/.chezmoitemplates/secrets/TAILSCALE_AUTH_KEY
```

> **Note:** Tailscale auth keys expire after 90 days maximum. You will need to generate a new key and re-encrypt it periodically. If anyone knows how to automatically keep the Tailscale API key up-to-date, please reach out on one of our [Community pages](https://install.doctor/community).

## Tailscale vs CloudFlare Tunnels

Both Tailscale and CloudFlare Tunnels provide network connectivity for devices behind firewalls:

| Feature | Tailscale | CloudFlare Tunnels |
|---|---|---|
| **Connection type** | Peer-to-peer mesh VPN (WireGuard) | Hub-and-spoke through CloudFlare's network |
| **Performance** | Direct connections between devices (faster) | Routed through CloudFlare data centers |
| **Best for** | Device-to-device communication | Public-facing services, SSO-protected access |
| **Encryption** | WireGuard (always encrypted) | TLS via CloudFlare |
| **Free tier** | 100 devices | Unlimited tunnels |
| **DNS** | MagicDNS (device-name.tailnet) | Custom subdomains on your domain |
| **Security features** | ACLs, exit nodes | Zero Trust policies, browser isolation, WAF |

**Recommendation:** Use Tailscale for device-to-device communication (SSH, file sharing, internal services) and CloudFlare Tunnels for public-facing services that need SSO protection. Install Doctor supports both simultaneously.
