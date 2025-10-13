#!/usr/bin/env bash
# @file Chrome Settings / Extensions
# @brief This script configures Chrome, Brave, and Chromium system-wide managed / recommended policies settings. It also pre-loads a configurable list of Chrome extensions to Chrome, Brave, Chromium, and Edge (if they are installed).
# @description
#     This Chrome setup script applies system-wide settings and pre-loads Chrome extensions into the browser profiles. The
#     extensions still must be enabled but they appear in the Chrome extensions menu and can be enabled with the toggle. The
#     system settings are applied to Chrome, Chromium, and Brave. Extensions are installed to the same browsers plus Microsoft Edge.
#
#     ## Features
#
#     * Adds `~/.config/chrome/managed.json` to the `managed/policies.json` system locations
#     * Adds `~/.config/chrome/recommended.json` to the `recommended/policies.json` system locations
#     * Pre-loads extension metadata for all the extensions defined under `chromeExtensions` in the [`home/.chezmoidata.yaml`](https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoidata.yaml) file
#
#     ## TODO
#
#     * Automatically enable the extensions that are pre-loaded
#     * Create several profiles with different characteristics (similar to the Firefox setup script)
#     * Ensure the directories that the script cycles through to install managed settings and extensions are complete for all installation types (i.e. there might need to be some additions for Flatpak installations since their folder structure is different)
#     * Document how [`chromium-flags.conf`](https://github.com/megabyte-labs/install.doctor/blob/master/home/dot_config/chromium-flags.conf) can be or is integrated
#
#     ## Links
#
#     * [`managed.json`](https://github.com/megabyte-labs/install.doctor/blob/master/home/dot_config/chrome/managed.json)
#     * [`recommended.json`](https://github.com/megabyte-labs/install.doctor/blob/master/home/dot_config/chrome/recommended.json)

set -Eeo pipefail
trap "gum log -sl error 'Script encountered an error!'" ERR

function chromeSetUp() {
  ### Ensure Chrome policies directory is present
  gum log -sl info 'Processing policy directories for Chromium based browsers'
  for POLICY_DIR in "/opt/google/chrome/policies"; do
    if [ -d "$(dirname "$POLICY_DIR")" ]; then
      ### Managed policies
      if [ ! -f "$POLICY_DIR/managed/policies.json" ]; then
        gum log -sl info "Ensuring directory $POLICY_DIR/managed exists"
        sudo mkdir -p "$POLICY_DIR/managed"
        gum log -sl info "Copying ${XDG_CONFIG_HOME:-$HOME/.config}/chrome/managed.json to $POLICY_DIR/managed/policies.json"
        sudo cp -f "${XDG_CONFIG_HOME:-$HOME/.config}/chrome/managed.json" "$POLICY_DIR/managed/policies.json"
      fi

      ### Recommended policies
      if [ ! -f "$POLICY_DIR/recommended/policies.json" ]; then
        gum log -sl info "Ensuring directory $POLICY_DIR/recommended exists" && sudo mkdir -p "$POLICY_DIR/recommended"
        gum log -sl info "Copying ${XDG_CONFIG_HOME:-$HOME/.config}/chrome/recommended.json to $POLICY_DIR/recommended/policies.json"
        sudo cp -f "${XDG_CONFIG_HOME:-$HOME/.config}/chrome/recommended.json" "$POLICY_DIR/recommended/policies.json"
      fi
    else
      gum log -sl info "Skipping extension injection into $POLICY_DIR - create these folders prior to running to create managed configs"
    fi
  done

  ### Add Chrome extension JSON
  gum log -sl info 'Populating Chrome extension JSON'
  for EXTENSION_DIR in "/opt/google/chrome/extensions" "$HOME/Library/Application Support/Google/Chrome/External Extensions"; do
    ### Ensure program-type is installed
    if [ -d "$(dirname "$EXTENSION_DIR")" ]; then
      ### Ensure extension directory exists
      if [[ "$EXTENSION_DIR" == '/opt/'* ]] || [[ "$EXTENSION_DIR" == '/etc/'* ]]; then
        if [ ! -d "$EXTENSION_DIR" ]; then
          gum log -sl info "Creating directory $EXTENSION_DIR" && sudo mkdir -p "$EXTENSION_DIR"
        fi
      else
        if [ ! -d "$EXTENSION_DIR" ]; then
          gum log -sl info "Creating directory $EXTENSION_DIR" && mkdir -p "$EXTENSION_DIR"
        fi
      fi

      ### Add extension JSON
      gum log -sl info "Adding Chrome extensions to $EXTENSION_DIR"
      while read EXTENSION; do
        gum log -sl info "Adding Chrome extension manifest ($EXTENSION)"
        if ! echo "$EXTENSION" | grep 'https://chrome.google.com/webstore/detail/' > /dev/null; then
          EXTENSION="https://chrome.google.com/webstore/detail/$EXTENSION"
        fi
        EXTENSION_ID="$(echo "$EXTENSION" | sed 's/^.*\/\([^\/]*\)$/\1/')"
        if [[ "$EXTENSION_DIR" == '/opt/'* ]] || [[ "$EXTENSION_DIR" == '/etc/'* ]]; then
          sudo cp -f "${XDG_CONFIG_HOME:-$HOME/.config}/chrome/extension.json" "$EXTENSION_DIR/${EXTENSION_ID}.json"
        else
          cp -f "${XDG_CONFIG_HOME:-$HOME/.config}/chrome/extension.json" "$EXTENSION_DIR/${EXTENSION_ID}.json"
        fi
      done< <(yq '.chromeExtensions[]' "${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/home/.chezmoidata.yaml")
    else
      gum log -sl info "$EXTENSION_DIR does not exist"
    fi
  done
}

chromeSetUp
