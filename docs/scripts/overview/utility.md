---
title: Utility Scripts Overview
description: Read about how you can invoke special scripts provided by the Install Doctor repository by leveraging curl. These scripts include features like fully automating the provisioning process and setting up SSO-based SSH certificates for improved security.
sidebar_label: Utility Scripts
slug: /scripts/utility
---

Install Doctor provides a handful of utility scripts that can be used to perform specific tasks. These scripts are housed in the `scripts/` folder (in the root of the Install Doctor repository).

## Kickstart Script

The `scripts/provision.sh` script is the quick-start script referenced by the Install Doctor home page. It is the preferred way of running Install Doctor on Linux / macOS systems. You can run this script by running the following:

```shell
bash <(curl -sSL https://install.doctor/start)
```

More details are provided on the [Kickstart Script documentation page](https://install.doctor/docs/scripts/utility/provision.sh).

## Homebrew Install Script

The `scripts/homebrew.sh` script is a helper script that installs Homebrew on Linux / macOS systems. It is provided as a convienience feature and can be run with the following snippet:

```shell
bash <(curl -sSL https://install.doctor/brew)
```

More details are provided on the [Homebrew Install Script documentation page](https://install.doctor/docs/scripts/utility/homebrew.sh).

## CloudFlare SSO SSH Script

The `scripts/cloudflared-ssh.sh` script automates the process of connecting devices to CloudFlare Teams so that you can access your devices (regardless of where they are on the internet) by leveraging short-lived certificates that are activated via Single Sign-On. In other words, these certificates are more secure because they automatically rotate and are easier to manage because they require logging into, say, Google to acquire the certificate for SSH access. After configuring CloudFlare and CloudFlare Teams as detailed in the script's documentation, you can run this script with:

```shell
bash <(curl -sSL https://install.doctor/ssh)
```

More details are provided on the [CloudFlare SSO SSH Script documentation page](https://install.doctor/docs/scripts/utility/cloudflared-ssh.sh).
