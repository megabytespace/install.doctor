---
title: Tailscale Integration
description: Learn about how Install Doctor integrates Tailscale to provide a WireGuard-powered LAN that is capable of connecting any two devices as long as they are connected to the internet.
sidebar_label: Tailscale
slug: /integrations/tailscale
---

Tailscale is used to create a WireGuard-based VPN network that connects all your devices to a shared LAN-like network. Tailscale is free for up to 20 devices. It is especially useful when connecting devices that are behind multiple firewalls and located in places where an internet connection is required for networking between devices.

## Configuration

Install Doctor will automatically connect your devices to the same Tailscale mesh VPN network if Tailscale is installed and the appropriate variables are provided. These variables include:

* `TAILSCALE_AUTH_KEY` - You can acquire this key from the [Tailscale admin settings dashboard](https://login.tailscale.com/admin/settings/keys). When there, click, "Generate auth key...," and check, "Reusable," "Ephemeral," and, "Pre-approved." Once you have the key, you can integrate it into your Install Doctor fork by using one of the methods described in the [Secrets documentation](https://install.doctor/docs/customization/secrets).

*Note: One caveat of Tailscale is that your API key must be rotated every 90 days since all keys have a maximum expiration date of 90 days after the key was created. If anyone knows how to automatically keep the Tailscale API key up-to-date, please reach out to us on one of our [Community pages](https://install.doctor/community).*

## CloudFlare Tunnel Comparison

CloudFlare Teams / Argo is another free service that we leverage to provide enhanced internet connectivity to devices that are possibly behind firewalls. Originally, CloudFlare tunnel endpoints were made to provide publicly HTTPS endpoints that were hosted behind firewalls. More recently, CloudFlare Argo / Teams / tunnels have evolved to provide all the features that Tailscale supports plus a lot more, with one exception.

In regards to connecting two devices to a mesh VPN, LAN-like network, Tailscale is still better than CloudFlare in regards to performance. CloudFlare tunnel traffic is all routed through CloudFlare's network (which gives you the ability to apply fancy security features and other interesting features). However, in many cases, Tailscale can establish direct peer-to-peer mesh VPN connections. This means, with Tailscale, your mesh VPN LAN network is faster.
