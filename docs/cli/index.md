---
title: CLI Reference
description: Find details on the CLI that Install Doctor implements to handle all the post-provision tasks that you will find useful. Learn how to backup browser settings to S3 buckets with a one-liner and more.
sidebar_label: Overview
slug: /cli
---

Install Doctor's CLI is powered by a `Taskfile.yml` file stored in `home/dot_config/task/Taskfile.yml`. The CLI can be used to execute tasks either with an easy-to-use, gorgeous terminal menu or by directly invoking tasks (which may be needed when leveraging the CLI in automated workflows).

## Task Menu

Install Doctor maintains its own fork of go-task called **[Task Menu](https://github.com/megabyte-labs/task-menu)**. The fork introduces several new features including the integration of several Charm Bracelet libraries. The most notable feature is perhaps the gorgeous terminal task runner TUI it provides. With it, you can easily browse through tasks along with their descriptions in an easy-to-use interface. You can invoke `task-menu` by running the following after provisioning a system with Install Doctor:

```shell
task-menu
```

You can learn more about our Task Menu project by checking out the [Task Menu GitHub repository](https://github.com/megabyte-labs/task-menu). The documentation provides installation instructions if you are interested in incorporating it with your own customized `Taskfile.yml`. Install Doctor automatically installs `task-menu` so you normally do not have to worry about this though.

## Invoking Tasks Directly

Alternatively, if you know the name of the CLI command you would like to run, you can directly invoke it by leveraging a helper executable script provided in `~/.local/bin/run` by running:

```shell
run task:name
```