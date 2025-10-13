#!/usr/bin/env bash
# @file Store Secrets in Keyring
# @brief Stores secret environment variables into the System keyring
# @description
#     This script imports secret environment variables into the System keyring if `envchain` is installed.
#     Secrets stored in the folder 'home/.chezmoitemplates/secrets' following the Install Doctor method are
#     imported into the System keyring by this script. There is only one namespace called `default` where the
#     secrets are stored. Executing `envchain default env` displays all the environment variables and their values.
#
#     ## Secrets
#
#     For more information about storing secrets like SSH keys and API keys, refer to our [Secrets documentation](https://install.doctor/docs/customization/secrets).
#
#     ## TODO
#
#     * Create seperate environments based on encrypted secret type (e.g. Allow `envchain cloudflare env` instead of `envchain default env` for everything)

set -Eeo pipefail
trap "gum log -sl error 'Script encountered an error!'" ERR

### Import environment variables into `envchain`
if command -v envchain > /dev/null; then
  if [ -f "$HOME/.config/age/chezmoi.txt" ]; then
    gum log -sl info 'Importing environment variables into the system keyring'
    ANSWERS=""
    KEY_NAMES=""
    while read ENCRYPTED_FILE; do
      gum log -sl info "Preparing secret for injection into system keyring via envchain" file "$(basename "$ENCRYPTED_FILE")"
      ### Populate token key ID
      KEY_NAME="$(basename "$ENCRYPTED_FILE")"
      if [ "$KEY_NAMES" == '' ]; then
        KEY_NAMES="$KEY_NAME"
      else
        KEY_NAMES="$KEY_NAMES $KEY_NAME"
      fi

      ### Populate token secret
      ANSWER="$(cat "$ENCRYPTED_FILE" | chezmoi decrypt)"
      if [ "$ANSWERS" == '' ]; then
        ANSWERS="$ANSWER"
      else
        ANSWERS="$ANSWERS $ANSWER"
      fi
    done< <(find "${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/home/.chezmoitemplates/secrets" -type f -maxdepth 1 -mindepth 1)

    ### Import keys into system keychain
    gum log -sl info "Importing secrets into keychain under the 'default' namespace (e.g. Use envchain default env to print all the tokens)"
    printf '%s\n' $ANSWERS | envchain --set default $KEY_NAMES
    gum log -sl info "Added Chezmoi-managed secrets into System keyring via envchain"
  else
    gum log -sl warn 'Unable to import any variables into envchain because ~/.config/age/chezmoi.txt was not created by the secrets encryption process yet'
  fi
else
  gum log -sl warn 'envchain is not installed or it is not available in the PATH'
fi
