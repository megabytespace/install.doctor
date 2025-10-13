#!/usr/bin/env bash
# @file VIM Plugins AOT Installation
# @brief This script triggers VIM to pre-install plugins so that VIM loads into the desired state the first time it is invoked

# @description This script installs the extensions defined in `${XDG_CONFIG_HOME:-$HOME/.config}/coc/extensions/package.json`
#     which should correlate to the Coc extensions defined in `${XDG_CONFIG_HOME:-$HOME/.config}/vim/vimrc`.
installCocExtensions() {
  if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/coc/extensions/package.json" ]; then
    gum log -sl info "Running npm i --no-progress --no-package-lock in ${XDG_CONFIG_HOME:-$HOME/.config}/coc/extensions"
    cd "${XDG_CONFIG_HOME:-$HOME/.config}/coc/extensions"
    npm i --no-progress --no-package-lock
  else
    gum log -sl info "Skipping Coc extension installation because ${XDG_CONFIG_HOME:-$HOME/.config}/coc/extensions/package.json is missing"
  fi
}

### Install VIM coc plugins
gum log -sl info "Updating VIM coc extensions" && installCocExtensions
