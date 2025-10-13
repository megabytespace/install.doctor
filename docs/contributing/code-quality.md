---
title: Code Quality
description: Find out what measures Install Doctor takes to ensure superior code quality. Learn how to abide by Install Doctor's style guide when contributing to the project.
sidebar_label: Code Quality
slug: /contributing/code-quality
---

Install Doctor is a product that provides base configurations for users' entire operating systems, and as such, the quality of its code must be of the highest standards. Good code quality ensures that software systems are scalable, maintainable, and reliable while being free from bugs and errors that could be harmful to users and businesses. Poor code quality can lead to expensive and time-consuming maintenance and refactoring efforts, which can delay project timelines and negatively impact software performance. Therefore, Install Doctor places great importance on code quality, recognizing that it is essential for the success of our product and the satisfaction of our users.

To achieve excellent code quality, Install Doctor has implemented several design patterns, similar to those already in use, the utilization of linters such as Shellcheck and ESLint, and adherence to popular language-specific style guides.

## Development Environment Setup

Contributors to Install Doctor can take advantage of automated auto-fixing and linting features by installing all the dependencies and rebuilding templated files. To do this, navigate to the root of the repository and run the following command:

```shell
bash start.sh
```

This command will install all development dependencies, regenerate templated files such as the README.md, and install git hooks that automatically lint changes and new files when running commands like `git commit`.

### Cloud-Based Development

All of the projects in the Megabyte Labs eco-system include a folder named `.devcontainer/`. This folder includes instructions for launching a full-featured Visual Studio Code cloud instance that already has the majority of system requirements pre-installed. You can either sign up and pay for this feature, which is integrated directly into GitHub, or reach out to us via one of the channels linked to on the Community page if you plan on actively developing Install Doctor using this feature. Alternatively, you can directly e-mail <a href="mailto:help@install.doctor.com">help@install.doctor</a>. We have invested a lot of time and money into developing Install Doctor, so we do not mind supporting our community developers in any way that might benefit them.

## Design Patterns

Maintaining a superior, easy-to-understand, and easy-to-get-started-with codebase requires following design patterns. Before opening any pull requests, browse through a good amount of the code that parallels the feature or fix you plan on pushing to our master branch. To do so, follow these steps:

1. Read the [Install Doctor documentation](/), which provides strategies that impact code design patterns.
2. Read the [Megabyte Labs eco-system documentation](https://megabyte.space/docs), which outlines additional details and references that will not only help you contribute better code to Install Doctor but will also help you become a better developer since it references many leading industry standards.
3. rowse through the Install Doctor codebase. For instance, if you are contributing a new `.local/bin/` script file, you should note that all of our other script files start with the `#!/usr/bin/env bash` shebang, as this is the ideal way of referencing the Bash program. There are many other subtleties contained within the codebase. Ideally, we want the codebase to look as if it were written by one Principal-level developer.

### Design Patterns Used in Scripts

During the provisioning process, Install Doctor utilizes bash (and PowerShell, in the case of Windows) scripts to handle application-specific logic that cannot easily be handled by structured YAML data. For the most part, all of these scripts are stored in `home/.chezmoiscripts/universal/`. If you sift through the code in this folder, you might notice some of the following code practices are employed:

1. All of the script files start with `run_onchange_after_` and end with `.tmpl`. The `run_` prefix marks the script as a script that needs to be run by Chezmoi during the provisioning process. The `onchange_` prefix marks the script as a script that should only run if the file has changed in content since the last time Chezmoi was run (more on this feature on the [Script Customization](/docs/customization/scripts) page). And, the `after_` prefix marks the script as a script that should run after Chezmoi applies the configuration file changes. The `.tmpl` ending tells Chezmoi that the script should be pre-rendered with Chezmoi's Go templating engine which allows you to inject variables from the `home/.chezmoi.yaml.tmpl` and `home/.chezmoidata.yaml` file, for instance.
2. Scripts that perform similar tasks contain the same number ID in the filename. In the future, when Install Doctor is more mature, it is possible that we will want to execute scripts asynchronously. If scripts have the same number ID, then we will be able to run those scripts at the same time in a group.
3. All of the bash scripts start with `{{- if ne .host.distro.family "windows" -}}` (and end with `{{ end -}}`). This tells Install Doctor to only run the script on non-Windows machines.
4. All of the scripts have a section at the top that include `{{ includeTemplate "universal/profile" }}` and `{{ includeTemplate "universal/logg" }}`. These blocks of code include the script sections defined in `home/.chezmoitemplates/`. These particular templates set up things like the `PATH` variable and add logging features that you can find examples of in the project.
5. Every action in a script should be wrapped in if-else blocks that include a check for system requirements required for the particular action. This might include checks for binaries by using `if command -v binary-name` or checks for the presence of configuration files by checking `if [ -f path/to/file ]`. In the else condition, you should always include a warning message in the form of `gum log -sl warn "Warning message about what if check failed"`.
6. All of the scripts that run should only run when required. If a script ensures that the latest version of Node.js is being used, then the script should only run when Node.js is installed. This can be accomplished by wrapping everything in a script file with an `if-else` that checks for system states that can make use of the logic. Or, when possible, you can leverage Go templating.
7. Chezmoi stored variables should be used whenever possible. This allows end-users to make framework-wide changes by editting their configuration files. For instance, if you want to delete a file in the home directory, you should reference the file using `{{ chezmoi.homeDir }}` Go template binding instead of the `$HOME` variable (while ensuring the file name ends with `.tmpl` to make sure Install Doctor parses it as a Go template).

There are dozens of other similarities you might find if you browse through the other scripts. When committing new changes, the code should be as good, if not better, than the existing code.

### File Permissions

To ensure top-notch security practices are employed, one of the things we do is ensure that all files have the lowest level of permission assigned to each file without hindering usability. When adding new files, you can use the `private_` prefix to make the file permissions scoped to the provisioning user. When new files are added by scripts, you should assign permissions manually via `chmod`, `chown`, or similar commands specific to the operating system you are modifying file permissions on.

## Linting

If you follow our advice and set up the development environment by running `bash start.sh`, linting tools will be installed. You can lint the whole project by running `task lint`. Similarly, you can apply auto-fixing by running `task fix`. The task definitions are stored in the `Taskfile.yml` that is stored at the root of the repository.

That said, you can actually just take advantage of the git hooks that `bash start.sh` installs. These hooks will automatically auto-fix and lint before allowing you to successfully `git commit` code.

## Style Guides

Whenever committing new scripts, you should pay attention to industry standard style guides such as the [Google style guides](https://google.github.io/styleguide/). Combining linting, auto-fixing, and the advice that industry-standard style guides recommend leads to better code. We encourage you to look through our full catalog of style guides on the [Megabyte Labs documentation on recommended style guides](https://megabyte.space/docs/philosophy/style-guides).

## Megabyte Labs Code

As mentioned, this project is maintained by Megabyte Labs. The documentation that details code design practices that should be followed by all projects within the Megabyte Labs eco-system should be read in conjunction with the documentation provided by Install Doctor. The documentation takes the recommendations laid out here a few steps further, with more in-depth recommendations, tips, and tricks. The Megabyte Labs documentation supplements the advice provided here but may be more generally applied to numerous types of projects.
