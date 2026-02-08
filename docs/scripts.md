---
title: Scripts Overview
description: Read about how Install Doctor incorporates shell scripting languages into the provisioning process. Learn about our integration of Bash and PowerShell.
sidebar_label: Overview
slug: /scripts
---

Shell scripting handles the bulk of the system configuration that Install Doctor manages. Scripts are grouped into categories based on when they execute during the provisioning lifecycle.

## Script Categories

| Category | When It Runs | Location | Description |
|---|---|---|---|
| [Before Scripts](/docs/scripts/before) | Before Chezmoi applies dotfiles | `home/.chezmoiscripts/universal/run_before_*` | System preparation: Homebrew, Age decryption, system packages |
| [After Scripts](/docs/scripts/after) | After Chezmoi applies dotfiles | `home/.chezmoiscripts/universal/run_after_*` | Software installation, service configuration, cleanup |
| [Profile Scripts](/docs/scripts/profile) | Every terminal session (Bash/ZSH) | `home/dot_config/shell/` | Aliases, exports, functions, MOTD |
| [Utility Scripts](/docs/scripts/utility) | On-demand via `curl` one-liners | `scripts/` | Kickstart, Homebrew install, CloudFlare SSH setup |

## Execution Flow

The provisioning process executes scripts in this order:

```
start.sh → provision.sh → chezmoi init/apply
                              ├── run_before_01-prepare.sh
                              ├── run_before_02-homebrew.sh
                              ├── run_before_03-decrypt-age-key.sh
                              ├── run_before_04-requirements.sh
                              ├── run_before_05-system.sh
                              ├── [Chezmoi applies dotfiles]
                              ├── run_after_01-pre-install.sh
                              ├── run_after_10-install.sh
                              ├── run_after_15-chezmoi-system.sh
                              ├── run_after_20-post-install.sh
                              └── run_after_24-cleanup.sh
```

Scripts run synchronously in filename order. The two-digit number after the prefix (`01`, `02`, etc.) controls execution order.

## Script Naming Conventions

| Prefix | Meaning | Example |
|---|---|---|
| `run_before_` | Runs before Chezmoi applies files | `run_before_02-homebrew.sh.tmpl` |
| `run_after_` | Runs after Chezmoi applies files | `run_after_10-install.sh.tmpl` |
| `run_onchange_` | Runs only when file content changes | `run_onchange_after_99-restart.sh.tmpl` |
| `.tmpl` suffix | File is a Go template rendered by Chezmoi | All script files use this |

*Note: All Chezmoi-invoked scripts currently execute during the Before and After stages. There are no "During" scripts.*