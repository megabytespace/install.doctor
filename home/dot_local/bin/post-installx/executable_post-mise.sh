#!/usr/bin/env bash
# @file Mise Install / Tweaks
# @brief Performs initial install of mise targets and applies tweaks such as symlinking mise's Java version with the system Java target on macOS

set -Eeo pipefail
trap "gum log -sl error 'Script encountered an error!'" ERR

if command -v mise > /dev/null; then
    gum log -sl info 'Running mise install' && mise install

    ### Symlink Java on macOS
    if [ -d /Applications ] && [ -d /System ]; then
        if [ -d "${XDG_DATA_HOME:-$HOME/.local/share}/mise/installs/java/openjdk-20/Contents" ] && [ ! -d "/Library/Java/JavaVirtualMachines/openjdk-20.jdk/Contents" ]; then
            gum log -sl info "Symlinking system Java to mise-installed Java" target "${XDG_DATA_HOME:-$HOME/.local/share}/mise/installs/java/openjdk-20/Contents" symlink "/Library/Java/JavaVirtualMachines/openjdk-20.jdk/Contents"
            sudo mkdir -p /Library/Java/JavaVirtualMachines/openjdk-20.jdk
            sudo ln -s "${XDG_DATA_HOME:-$HOME/.local/share}/mise/installs/java/openjdk-20/Contents" /Library/Java/JavaVirtualMachines/openjdk-20.jdk/Contents
        fi
    fi
else
    gum log -sl info 'mise is not available on the PATH'
fi
