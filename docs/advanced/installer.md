---
title: Software Installer
description: Learn about Install Doctor's custom, multi-OS software package installer. Find out how it works, why it is fast, and why it is better than alternative methods.
sidebar_label: Installer
slug: /features/installer
---

Install Doctor leverages a custom, multi-OS capable software package installer written in ZX to handle the bulk of the provisioning process. When passed an array of a software package names, the installer leverages a growing software package map stored in the `software.yml` file found in the root of the Install Doctor repository to intelligently determine which installation method use. It is optimized to re-provision a system as quickly as possible by determining whether software is already installed and updating outdated software. The YAML syntax that it supports is powerful, configurable, and multi-OS capable.

An in-depth overview of the installer is coming soon and will be published on this page.
