#!/usr/bin/env bash
# @file Atuin Initialization
# @brief Registers with atuin, logs in, imports command history, and synchronizes

set -Eeo pipefail
trap "gum log -sl error 'Script encountered an error!'" ERR

if command -v atuin > /dev/null; then
    if get-secret --exists ATUIN_USERNAME ATUIN_EMAIL ATUIN_PASSWORD ATUIN_KEY; then
        gum log -sl info 'Registering Atuin account'
        atuin register -u "$(get-secret ATUIN_USERNAME)" -e "$(get-secret ATUIN_EMAIL)" -p "$(get-secret ATUIN_PASSWORD)" || true
        gum log -sl info 'Logging into Atuin account'
        atuin login -u "$(get-secret ATUIN_USERNAME)" -p "$(get-secret ATUIN_PASSWORD)" -k "$(get-secret ATUIN_KEY)"
        gum log -sl info 'Running atuin import auto'
        atuin import auto
        gum log -sl info 'Running atuin sync'
        atuin sync
    fi
else
    gum log -sl info 'atuin is not available in the PATH'
fi
