<!-- ⚠️ This README has been generated from the file(s) ".config/docs/blueprint-readme-misc.md" ⚠️--><div align="center">
  <center>
    <a href="https://github.com/megabyte-labs/install.doctor">
      <img width="320" alt="Install Doctor logo" src="https://gitlab.com/megabyte-labs/install.doctor/-/raw/master/docs/logo-full.png" />
    </a>
  </center>
</div>
<div align="center">
  <center><h1 align="center"><i></i>Install Doctor, The Desktop Provisioning System<i></i></h1></center>
  <center><h4 style="color: #18c3d1;">Maintained by <a href="https://megabyte.space" target="_blank">Megabyte Labs</a></h4><i></i></center>
</div>

<div align="center">
  <a href="https://megabyte.space" title="Megabyte Labs homepage" target="_blank">
    <img alt="Homepage" src="https://img.shields.io/website?down_color=%23FF4136&down_message=Down&label=Homepage&logo=home-assistant&logoColor=white&up_color=%232ECC40&up_message=Up&url=https%3A%2F%2Fmegabyte.space&style=for-the-badge" />
  </a>
  <a href="https://github.com/megabyte-labs/install.doctor/blob/master/docs/CONTRIBUTING.md" title="Learn about contributing" target="_blank">
    <img alt="Contributing" src="https://img.shields.io/badge/Contributing-Guide-0074D9?logo=github-sponsors&logoColor=white&style=for-the-badge" />
  </a>
  <a href="https://app.slack.com/client/T01ABCG4NK1/C01NN74H0LW/details/" title="Chat with us on Slack" target="_blank">
    <img alt="Slack" src="https://img.shields.io/badge/Slack-Chat-e01e5a?logo=slack&logoColor=white&style=for-the-badge" />
  </a>
  <a href="https://app.element.io/#/room/#install.doctor:matrix.org" title="Chat with the community via Matrix.org" target="_blank">
    <img alt="Matrix" src="https://img.shields.io/matrix/install.doctor:matrix.org?logo=matrix&logoColor=white&style=for-the-badge" />
  </a>
  <a href="https://github.com/megabyte-labs/install.doctor" title="GitHub mirror" target="_blank">
    <img alt="GitHub" src="https://img.shields.io/badge/Mirror-GitHub-333333?logo=github&style=for-the-badge" />
  </a>
  <a href="https://gitlab.com/megabyte-labs/install.doctor" title="GitLab repository" target="_blank">
    <img alt="GitLab" src="https://img.shields.io/badge/Repo-GitLab-fc6d26?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgAQMAAABJtOi3AAAABlBMVEUAAAD///+l2Z/dAAAAAXRSTlMAQObYZgAAAHJJREFUCNdNxKENwzAQQNEfWU1ZPUF1cxR5lYxQqQMkLEsUdIxCM7PMkMgLGB6wopxkYvAeI0xdHkqXgCLL0Beiqy2CmUIdeYs+WioqVF9C6/RlZvblRNZD8etRuKe843KKkBPw2azX13r+rdvPctEaFi4NVzAN2FhJMQAAAABJRU5ErkJggg==&style=for-the-badge" />
  </a>
</div>

> </br><h4 align="center">**A glorious combination of application / theme settings and a performant cross-platform, desktop-oriented software suite.**</h4></br>

<a href="#table-of-contents" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
  - [Quick Start Notes](#quick-start-notes)
- [Chezmoi-Based](#chezmoi-based)
- [Security Focused](#security-focused)
- [Cross-Platform](#cross-platform)
  - [Custom Software Provisioning System](#custom-software-provisioning-system)
  - [Beautiful Anywhere](#beautiful-anywhere)
  - [Qubes Support](#qubes-support)
- [Gas Station](#gas-station)
- [Chezmoi](#chezmoi)
  - [Resetting Chezmoi](#resetting-chezmoi)
- [Contributing](#contributing)
  - [Affiliates](#affiliates)
- [License](#license)

<a href="#overview" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Overview

Want to try out a new desktop jam-packed with a whole suite of GitHub's most-starred projects? Install Doctor is a combination of application settings, theme files, and a performant yet flexible software installer written with [ZX](https://github.com/google/zx). It is easily customizable, with optional prompts that ask you for API keys if you want to completely automate everything. The installer supports almost any operating system, just checkout the [software.yml file](https://gitlab.com/megabyte-labs/install.doctor/-/blob/master/software.yml). It uses [Chezmoi](https://github.com/twpayne/chezmoi) to apply file changes in an interactive way. It is not your typical Chezmoi project - it is built around the philosophy that you should be able to bash all your computers to bits with a hammer and then resurrect them the next day ✝️️ by storing stateful data to an encrypted S3 bucket and automating desktop configuration as much as possible.

Install Doctor is a cross-platform development environment provisioning system. The project began as an ongoing Ansible project named [Gas Station](https://github.com/megabyte-labs/gas-station) but transitioned to a dotfile-ish approach for easier adoption and less overhead. It is intended for:

1. Power users that want to maximize their long-term efficiency by incorporating the [most-starred applications / projects / CLIs on GitHub](https://stars.megabyte.space) into their stack.
2. Users that distro hop but want to retain their favorite tools regardless of whether they are using macOS, Windows, or Linux
3. People that want to reformat their computers on a, perhaps, daily basis while retaining stateful elements of their file system by leveraging S3 buckets
4. Enthusiasts that want to deploy as many cool, useful tools as possible without having to spend much time configuring their file system
5. Perfectionists that love software that behaives as it should, looks gorgeous (desktop preview screenshots below), and performs tasks quickly on any platform
6. CLI ninjas that want to bring their set of tools wherever they go

<a href="#quick-start" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Quick Start

To provision your workstation, you can run the following which will install some basic dependencies (e.g. Chezmoi) and provide interactive prompts where you can personalize your configuration:

```
bash <(curl -sSL https://install.doctor/start)
```

If you fork this repository and would like to use your fork as the source, you can still use the command shown above by setting the `START_REPO` environment variable. If it is located on GitHub, you can do this by running:

```
START_REPO=my-gh-user/my-fork-name bash <(curl -sSL https://install.doctor/start)
```

Alternatively, if you want to host your project on GitLab or another git provider, then just specify the git remote's URL:

```
START_REPO=git@gitlab.com:megabyte-labs/install.doctor.git bash <(curl -sSL https://install.doctor/start)
```

### Quick Start Notes

- The quick start script is tested on the latest versions of Archlinux, CentOS, Debian, Fedora, macOS, and Ubuntu
- The quick start script is the preferred method of using this project to provision your system
- The script can be configured to be completely headless by specifying environment variables which are detailed below
- _Windows support is on the roadmap._

<a href="#chezmoi-based" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Chezmoi-Based

This project leverages [Chezmoi](https://github.com/twpayne/chezmoi) to provide:

1. File diffs that show how files are being changed
2. Easy-to-use encryption that lets you store private data publicly on GitHub
3. A basic set of prompts that accept and integrate API credentials for services like CloudFlare, GitHub, GitLab, and Slack so that your development environment is augmented by free cloud services

<a href="#security-focused" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Security Focused

This software was built in an adversarial environment. This led towards a focus on security which is why we employ technologies like [Firejail](https://github.com/netblue30/firejail), [Portmaster](https://safing.io/), [Little Snitch](https://www.obdev.at/products/littlesnitch/index.html), and [Qubes](https://www.qubes-os.org/). Whenever possible, Flatpaks are used as the preferred application type. This also led to an emphasis on performance. When your workstation is possibly compromised or you have a good habit of reformatting your workstation on regular basis then it makes sense to use a provisioning system that can restore the workstation to a similar state quicker.

<a href="#cross-platform" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Cross-Platform

This project has been developed with support for Archlinux, CentOS, Fedora, macOS, Ubuntu, and Windows. Almost all the testing has been done on x86_64 systems but the system is flexible enough to be adapted for other systems such as ARM or FreeBSD. A lot of effort has also gone into supporting Qubes which, when fully provisioned, is basically a combination of all the operating systems we have developed this project for.

### Custom Software Provisioning System

The project also incorporates a custom [ZX](https://github.com/google/zx) script that allows you to choose which package managers you would like to manage your software. It attempts to be as asynchronous as possible without opening the door to errors. The script leverages the [software.yml](/software.yml) file in the root of this repository to figure out which package manager to use. By default, the installer will choose the most secure option (e.g. Flatpaks are preferred for Linux applications). The installer is more performant and less error-prone than our Ansible variant. It also makes it a lot easier to add software to your stack in such a way that you can keep the software regardless of what operating system you are using by storing everything in the aforementioned `software.yml` file.

### Beautiful Anywhere

Windows and macOS do a great job of making things look good from a UI perspective out of the box. Linux on the other hand requires some finessing especially when you follow our philosophy of taking many different operating systems and deploying similar software on them. A sizable amount of effort went into customizing the popular [Sweet](https://github.com/EliverLara/Sweet) theme and adapting it to our liking. Bells and whistles like a customized GRUB2 and Plymouth theme are included.

### Qubes Support

Qubes support is on its way.

<a href="#gas-station" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Gas Station

This project began as something to supplement our provisioning system that uses Ansible. The system is called [Gas Station](https://gitlab.com/megabyte-labs/gas-station). It includes hundreds of Ansible roles. If you look at the [`software.yml`](/software.yml) file, you will notice that some of the Ansible roles that Gas Station provides are inside of it. By default, this project will try to install software / dependencies using other, lighter methods before resorting to using Ansible. This is because of the software installer order that is defined at the top of the software.yml file. Gas Station is also still used to house some of the variables / data that this project uses.

<a href="#chezmoi" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Chezmoi

This project uses Chezmoi to orchestrate the provisioning. After calling the quick start script shown above, the quick start script will ensure some dependencies are installed (including Chezmoi) and then initiate Chezmoi. In order to customize this project, you should head over to the Chezmoi documentation to get a better understanding of why some of the files in this repository start with `dot_`, `run_`, etc.

### Resetting Chezmoi

This script is designed to run only the code that is necessary to improve performance. This is accomplished by using [`.chezmoiscripts`](home/.chezmoiscripts), Chezmoi's `onchange_` identifier, and a custom installer written in ZX that is powered by the software definitions in [`software.yml`](software.yml).

If there is an error during the provision process or you make changes that are not being run during the provision process then you might want to clear Chezmoi's cache and configuration. This can be done on macOS/Linux by running:

```
rm -rf ~/.config/chezmoi && rm -rf ~/.cache/chezmoi
```

<a href="#contributing" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/megabyte-labs/install.doctor/issues). If you would like to contribute, please take a look at the [contributing guide](https://github.com/megabyte-labs/install.doctor/blob/master/docs/CONTRIBUTING.md).

<details>
<summary><b>Sponsorship</b></summary>
<br/>
<blockquote>
<br/>
Dear Awesome Person,<br/><br/>
I create open source projects out of love. Although I have a job, shelter, and as much fast food as I can handle, it would still be pretty cool to be appreciated by the community for something I have spent a lot of time and money on. Please consider sponsoring me! Who knows? Maybe I will be able to quit my job and publish open source full time.
<br/><br/>Sincerely,<br/><br/>

**_Brian Zalewski_**<br/><br/>

</blockquote>

<a title="Support us on Open Collective" href="https://opencollective.com/megabytelabs" target="_blank">
  <img alt="Open Collective sponsors" src="https://img.shields.io/opencollective/sponsors/megabytelabs?logo=opencollective&label=OpenCollective&logoColor=white&style=for-the-badge" />
</a>
<a title="Support us on GitHub" href="https://github.com/ProfessorManhattan" target="_blank">
  <img alt="GitHub sponsors" src="https://img.shields.io/github/sponsors/ProfessorManhattan?label=GitHub%20sponsors&logo=github&style=for-the-badge" />
</a>
<a href="https://www.patreon.com/ProfessorManhattan" title="Support us on Patreon" target="_blank">
  <img alt="Patreon" src="https://img.shields.io/badge/Patreon-Support-052d49?logo=patreon&logoColor=white&style=for-the-badge" />
</a>

### Affiliates

Below you will find a list of services we leverage that offer special incentives for signing up for their services through our special links:

<a href="http://eepurl.com/h3aEdX" title="Sign up for $30 in MailChimp credits" target="_blank">
  <img alt="MailChimp" src="https://cdn-images.mailchimp.com/monkey_rewards/grow-business-banner-2.png" />
</a>
<a href="https://www.digitalocean.com/?refcode=751743d45e36&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge">
  <img src="https://web-platforms.sfo2.digitaloceanspaces.com/WWW/Badge%203.svg" alt="DigitalOcean Referral Badge" />
</a>

</details>

<a href="#license" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## License

Copyright © 2020-2021 [Megabyte LLC](https://megabyte.space). This project is [MIT](https://gitlab.com/megabyte-labs/install.doctor/-/blob/master/LICENSE) licensed.
