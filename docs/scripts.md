---
title: Scripts Overview
description: Read about how Install Doctor incorporates shell scripting languages into the provisioning process. Learn about our integration of Bash and PowerShell.
sidebar_label: Overview
slug: /scripts
---

Shell scripting is leveraged to handle the bulk of the configurations that Install Doctor manages. The scripts are grouped into several different categories that indicate when the scripts are invoked.

## Script Categories

1. **[Before Scripts](https://install.doctor/docs/scripts/before):** These scripts are invoked by Chezmoi, prior to Chezmoi applying the managed configuration files (stored in `home/.chezmoiscripts/universal/`)
2. **During Scripts:** Invoked by Chezmoi while the configuration files are being applied (stored in `home/.chezmoiscripts/universal/`)
3. **[After Scripts](https://install.doctor/docs/scripts/after):** Invoked by Chezmoi after the configuration files have been added to the device (stored in `home/.chezmoiscripts/universal/`)
4. **[Profile Scripts](https://install.doctor/docs/scripts/profile):** These scripts are used by the terminal whenever Bash or ZSH is used after the provisioning process, when the configurations are already in use (stored in `home/dot_config/shell/`)
5. **[Utility Scripts](https://install.doctor/docs/scripts/utility):** These scripts are stored in the `scripts/` folder in the root of Install Doctor repository and are used to provide various tasks including invoking the Install Doctor provisioning process (e.g. `bash <(curl -sSL https://install.doctor/start)` links to the `scripts/provision.sh` file)

*Note: All of the Chezmoi-invoked scripts are currently applied during the Before and After stage so there are currently no "During Scripts".*