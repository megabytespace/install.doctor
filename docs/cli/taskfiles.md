---
title: Taskfiles
description: Learn about how Install Doctor leverages the go-task project's Taskfile.yml format to simultaneously house scripts alongside accompanying documentation written in markdown.
sidebar_label: Taskfiles
slug: /cli/taskfiles
---

Install Doctor's CLI is powered by our fork of the [go-task](https://github.com/go-task/task) project. go-task is a shell script task runner that supports a handful of useful features such as the ability to run tasks in parallel (for performance), designate tasks to only run once by maintaining a history cache (for efficiency), include documentation alongside the shell script code (for documentation), and the ability to manage dependencies (for compatibility).

## CLI Customization

If you are looking to customize the CLI that Install Doctor provides, you will likely have to modify the `Taskfile.yml` that defines all the various CLI commands. This file is located in `home/dot_config/task/Taskfile.yml`.

If you are modifying any `Taskfile.yml`, a great starting point is looking at the [official go-task documentation](https://taskfile.dev/usage/).
