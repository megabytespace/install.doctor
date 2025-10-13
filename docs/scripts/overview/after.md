---
title: After Scripts Overview
description: Read about how Install Doctor incorporates shell scripting languages into the provisioning process by running scripts after the configuration files have been applied. Learn about our integration of Bash and PowerShell.
sidebar_label: After Scripts
slug: /scripts/after
---

Certain scripts included in the Install Doctor project have to run after the configuration files have been generated and applied to the system. Some of these scripts copy configurations from the project to a specific system location and then enable / restart a service, for instance. All of these files include `after_` in their filename and are located in the `home/.chezmoiscripts/universal/` folder. The majority of the scripts leveraged by Install Doctor are kept in the `universal/` folder so that the script execution order can be controlled.

## Script Execution Order

Just like the [Before Scripts](https://install.doctor/docs/scripts/before), the scripts run synchronously in order of file name. This is why all of the files include a two-digit numerical identifier after their file name directives. This two-digit numerical identifier provides a way of controlling the order that the scripts execute.

For example, the file `home/.chezmoiscripts/universal/run_before_01-decrypt-age-key.sh.tmpl` has a numerical identifier of `01`. This identifier causes the script to be listed alphabetically before other scripts with higher numerical identifiers.

## Provision Completion

After all of the *After Scripts* have executed, the Chezmoi-based provisioning process has finished. However, depending on how you initialized the provisioning process, there might be some logic that runs after these scripts. For example, if you launched the provisioning process by running `bash <(curl -sSL https://install.doctor/start)`, then some clean up logic run after the scripts and instructions / logs will be printed.

## Links

* [`universal/` scripts folder](https://github.com/megabyte-labs/install.doctor/tree/master/home/.chezmoiscripts/universal)
* [Chezmoi scripting documentation](https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/)
