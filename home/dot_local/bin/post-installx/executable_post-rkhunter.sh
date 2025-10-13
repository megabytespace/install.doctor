#!/usr/bin/env bash
# @file rkhunter configuration
# @brief This script applies the rkhunter integration and updates it as well

set -Eeo pipefail
trap "gum log -sl error 'Script encountered an error!'" ERR

if command -v rkhunter > /dev/null; then
    if [ -d /Applications ] && [ -d /System ]; then
      ### macOS
      gum log -sl info 'Updating file "$(brew --prefix)/Cellar/rkhunter/1.4.6/etc/rkhunter.conf"' && gsed -i  "s/^#WEB_CMD.*$/WEB_CMD=curl\ -L/" "$(brew --prefix)/Cellar/rkhunter/1.4.6/etc/rkhunter.conf"
      export PATH="$(echo "$PATH" | gsed 's/VMware Fusion.app/VMwareFusion.app/g')"
      export PATH="$(echo "$PATH" | gsed 's/IntelliJ IDEA CE.app/IntelliJIDEACE.app/g')"
    else
      ### Linux
      gum log -sl info 'Updating file /etc/rkhunter.conf' && sed -i  "s/^#WEB_CMD.*$/WEB_CMD=curl\ -L/" /etc/rkhunter.conf
    fi
    sudo rkhunter --propupd || gum log -sl warn "sudo rkhunter --propupd returned non-zero exit code"
    sudo rkhunter --update || gum log -sl warn "sudo rkhunter --update returned non-zero exit code"
else
    gum log -sl info 'rkhunter is not installed'
fi
