#!/usr/bin/env bash

### Load AWS secrets
if [ -d /Applications ] && [ -d /System ] && [ ! -d /Applications/Xcode.app ]; then
    ### Remove old files
    gum log -sl info 'Removing old ~/.xcodeinstall folder' && rm -rf ~/.xcodeinstall

    ### Ensure xcodeinstall installed
    if ! command -v xcodeinstall > /dev/null; then
        gum log -sl info 'Installing xcodeinstall'
        brew install sebsto/macos/xcodeinstall
    fi

    ### Authenticate
    gum log -sl info 'Authenticating with AWS via xcodeinstall'
    xcodeinstall authenticate -s "$AWS_DEFAULT_REGION"

    ### Download files
    while read XCODE_DOWNLOAD_ITEM; do
      if [[ "$XCODE_DOWNLOAD_ITEM" != *"Command Line Tools"* ]]; then
        DOWNLOAD_ID="$(echo "$XCODE_DOWNLOAD_ITEM" | sed 's/^\[\(.*\)\] .*/\1/')"
        gum log -sl info "Downloading $XCODE_DOWNLOAD_ITEM"
        echo "$DOWNLOAD_ID" | xcodeinstall download -s "$AWS_DEFAULT_REGION"
      fi
    done < <(xcodeinstall list -s "$AWS_DEFAULT_REGION" | grep --invert-match 'Release Candidate' | grep --invert-match ' beta ' | grep ' Xcode \d\d ')
    
    ### Install Xcode
    gum log -sl info 'Installing Xcode'
    xcodeinstall install --name "$(basename "$(find ~/.xcodeinstall/download -maxdepth 1 -name "*.xip")")"

    ### Install Command Line Tools
    # Commentted out because it is already installed by xcode-select in the provision.sh script
    # xcodeinstall install --name "$(basename "$(find ~/.xcodeinstall/download -maxdepth 1 -name "*Command Line Tools*")")"

    ### Install Additional Tools
    gum log -sl info 'Installing Additional Tools'
    while read ADDITIONAL_TOOLS; do
      hdiutil attach "$ADDITIONAL_TOOLS"
      rm -rf "/Applications/Additional Tools"
      cp -rf "/Volumes/Additional Tools" "/Applications/Additional Tools"
      hdiutil detach "$(find /Volumes -name "Additional Tools")"
    done < <(find ~/.xcodeinstall/download -name "Additional Tools*")

    ### Install Font Tools
    gum log -sl info 'Installing Font Tools'
    while read FONT_TOOLS; do
      hdiutil attach "$FONT_TOOLS"
      cd "$(find /Volumes -maxdepth 1 -name "*Font Tools*")"
      sudo installer -pkg "$(find . -maxdepth 1 -name "*Font Tools*.pkg")" -target /
      cd / && hdiutil detach "$(find /Volumes -maxdepth 1 -name "*Font Tools*")"
    done < <(find ~/.xcodeinstall/download -name "Font Tools*")

    ### Remove cache / downloaded files
    rm -rf ~/.xcodeinstall
fi