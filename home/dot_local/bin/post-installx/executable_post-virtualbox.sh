#!/usr/bin/env bash
# @file VirtualBox Extension Pack
# @brief Ensures the VirtualBox extension pack is installed.
# @description
#     This script ensures the VirtualBox extension pack that corresponds with VirtualBox's version is properly installed.

set -Eeo pipefail
trap "gum log -sl error 'Script encountered an error!'" ERR

### Run logic if VirtualBox is installed
if command -v VirtualBox >/dev/null; then
  ### Install VirtualBox extension pack if it is not installed already
  if [ ! -d /usr/lib/virtualbox/ExtensionPacks/Oracle_VM_VirtualBox_Extension_Pack ] && [ ! -d /Applications/VirtualBox.app/Contents/MacOS/ExtensionPacks/Oracle_VM_VirtualBox_Extension_Pack ]; then
    gum log -sl info 'Acquiring VirtualBox version information'
    VBOX_VERSION="$(VirtualBox --help | head -n 1 | sed -n 's/.*v\([0-9]\+\.[0-9]\+\.[0-9]\+\).*/\1/p')"
    ### Set up folders
    # Check for macOS installation before creating ExtensionPacks folder on Linux machines
    if [ ! -d /Applications/VirtualBox.app ]; then
      sudo mkdir -p /usr/lib/virtualbox/ExtensionPacks
    fi
    mkdir -p /tmp/vbox
    cd /tmp/vbox
    ### Download extension pack
    gum log -sl info 'Downloading VirtualBox extension pack'
    wget -q -O "/tmp/vbox/Oracle_VM_VirtualBox_Extension_Pack-$VBOX_VERSION.vbox-extpack" "https://download.virtualbox.org/virtualbox/$VBOX_VERSION/Oracle_VirtualBox_Extension_Pack-$VBOX_VERSION.vbox-extpack" || gum log -sl error 'Failed to download the VirtualBox extension pack so the extension pack installation will be skipped'
    ### Install extension pack
    if [[ -f "/tmp/vbox/Oracle_VM_VirtualBox_Extension_Pack-${VBOX_VERSION}.vbox-extpack" ]]; then
      gum log -sl info 'Installing VirtualBox extension pack'
      echo 'y' | sudo VBoxManage extpack install --replace "/tmp/vbox/Oracle_VM_VirtualBox_Extension_Pack-$VBOX_VERSION.vbox-extpack"
      gum log -sl info 'Successfully installed VirtualBox extension pack'
    fi
  else
    gum log -sl info 'VirtualBox Extension pack is already installed'
  fi
else
  gum log -sl info 'VirtualBox is not installed so VirtualBox Extension pack will not be installed'
fi
