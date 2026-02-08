---
title: Taskfiles
description: Learn about how Install Doctor leverages the go-task project's Taskfile.yml format to simultaneously house scripts alongside accompanying documentation written in markdown.
sidebar_label: Taskfiles
slug: /cli/taskfiles
---

Install Doctor's CLI is powered by our fork of the [go-task](https://github.com/go-task/task) project. go-task is a shell script task runner that supports parallel execution, one-time run caching, inline documentation, and dependency management.

## Taskfile Format

Tasks are defined in YAML with a simple, declarative structure. Here is an example task definition:

```yaml
tasks:
  browser:profile:backup:
    desc: Backup browser profiles to an S3-compatible bucket
    summary: |
      # Backup Browser Profiles
      Backs up Chrome, Firefox, and Edge profiles to the configured
      S3-compatible storage bucket using rclone.
    cmds:
      - task: browser:chrome:backup
      - task: browser:firefox:backup
      - task: browser:edge:backup

  browser:chrome:backup:
    desc: Backup Chrome profile to S3
    cmds:
      - |
        if command -v rclone > /dev/null; then
          rclone sync "$HOME/.config/google-chrome" "s3:backups/chrome"
        fi
```

## Key Taskfile Features

| Feature | Syntax | Description |
|---|---|---|
| Description | `desc: "..."` | Short one-line description shown in task menu |
| Summary | `summary: \|` | Detailed markdown documentation for the task |
| Dependencies | `deps: [task1, task2]` | Tasks that must complete before this task runs |
| Parallel execution | `deps:` (multiple) | Dependencies run in parallel by default |
| Conditional execution | `status:` or `preconditions:` | Skip task if conditions are already met |
| Variables | `vars:` | Task-level or global variable definitions |

## CLI Customization

To customize the CLI, modify the Taskfile at `home/dot_config/task/Taskfile.yml`. This file is deployed to `~/.config/task/Taskfile.yml` during provisioning.

```shell
# View the deployed Taskfile
cat ~/.config/task/Taskfile.yml

# Run a specific task directly
run browser:profile:backup

# Use the interactive task menu
task-menu
```

For the full Taskfile specification, see the [official go-task documentation](https://taskfile.dev/usage/).
