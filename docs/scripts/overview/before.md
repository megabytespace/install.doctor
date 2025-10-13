---
title: Before Scripts Overview
description: Read about how Install Doctor incorporates shell scripting languages into the provisioning process by running scripts before the Chezmoi file provisioning process.
sidebar_label: Before Scripts
slug: /scripts/before
---

Certain scripts included in the Install Doctor project have to run before the configuration files have been generated and applied to the system. These scripts prepare the system by ensuring private keys used for encryption are available and that the required provisioning programs are available on the system. All of these files include `before_` in their filename and are located in the `home/.chezmoiscripts/universal/` folder. The majority of the scripts leveraged by Install Doctor are kept in the `universal/` folder so that the script execution order can be controlled.

## Script Execution Order

Just like the [After Scripts](https://install.doctor/docs/scripts/after), the *Before Scripts* run synchronously in order of file name. This is why all of the files include a two-digit numerical identifier after their file name directives. This two-digit numerical identifier provides a way of controlling the order that the scripts execute.

For example, the file `home/.chezmoiscripts/universal/run_before_01-decrypt-age-key.sh.tmpl` has a numerical identifier of `01`. This identifier causes the script to be listed alphabetically before other scripts with higher numerical identifiers.

## Links

* [`universal/` scripts folder](https://github.com/megabyte-labs/install.doctor/tree/master/home/.chezmoiscripts/universal)
* [Chezmoi scripting documentation](https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/)
