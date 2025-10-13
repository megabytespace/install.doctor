#!/usr/bin/env bash
# @file NTFY Dependencies
# @brief Eensures system dependencies are installed

set -Eeo pipefail
trap "gum log -sl error 'Script encountered an error!'" ERR

if command -v ntfy > /dev/null; then
    ### Debian dependency
    if command -v apt-get > /dev/null; then
        gum log -sl info 'Running sudo apt-get update && sudo apt-get install -y python-dbus'
        sudo apt-get update && sudo apt-get install -y python-dbus
    fi

    ### Termux dependency
    if command -v termux-setup-storage > /dev/null; then
        gum log -sl info 'Running apt install -y termux-api'
        apt install -y termux-api
    fi
else
    gum log -sl info 'ntfy not available on PATH'
fi
