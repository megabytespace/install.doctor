#!/usr/bin/env bash
# @file Volta initialization
# @brief This script initializes Volta and ensures the latest version of node and yarn are installed

set -Eeo pipefail
trap "gum log -sl error 'Script encountered an error!'" ERR

export VOLTA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/volta"
export PATH="$VOLTA_HOME/bin:$PATH"

### Disconnect from CloudFlare WARP (if connected)
if command -v warp-cli > /dev/null; then
  warp-cli disconnect && gum log -sl info 'CloudFlare WARP temporarily disconnected while Volta installs Node / Yarn'
fi

### Configure Volta if it is installed
if command -v volta > /dev/null; then
    gum log -sl info 'Running volta setup'
    volta setup
    gum log -sl info 'Installing latest version of Node.js via Volta'
    volta install node@latest
    gum log -sl info 'Installing latest version of Yarn via Volta'
    volta install yarn@latest
else
    gum log -sl info 'Volta is not installed'
fi
