#!/usr/bin/env bash
set -o pipefail
# @file Quick Start Provision Script
# @brief Main entry point for Install Doctor that ensures Homebrew and a few dependencies are installed before cloning the repository and running Chezmoi.
# @description
#     This script ensures Homebrew is installed and then installs a few dependencies that Install Doctor relies on.
#     After setting up the minimal amount of changes required, it clones the Install Doctor repository (which you
#     can customize the location of so you can use your own fork). It then proceeds by handing things over to
#     Chezmoi which handles the dotfile application and synchronous scripts. Task is used in conjunction with
#     Chezmoi to boost the performance in some spots by introducing asynchronous features.
#
#     **Note**: `https://install.doctor/start` points to this file.
#
#     ## Dependencies
#
#     The chart below shows the dependencies we rely on to get Install Doctor going. The dependencies that are bolded
#     are mandatory. The ones that are not bolded are conditionally installed only if they are required.
#
#     | Dependency         | Description                                                                          |
#     |--------------------|--------------------------------------------------------------------------------------|
#     | **Chezmoi**        | Dotfile configuration manager (on-device provisioning)                               |
#     | **Task**           | Task runner used on-device for task parallelization and dependency management         |
#     | **ZX / Node.js**   | ZX is a Node.js abstraction that allows for better scripts                           |
#     | Gum                | Terminal UI prompt CLI (provides interactive prompts and styled output)               |
#     | Glow               | Markdown renderer used for applying terminal-friendly styles to markdown             |
#
#     There are also a handful of system packages that are installed like `curl` and `git`. Then, during the Chezmoi provisioning
#     process, there are a handful of system packages that are installed to ensure things run smoothly. You can find more details
#     about these extra system packages by browsing through the `home/.chezmoiscripts/${DISTRO_ID}/` folder and other applicable
#     folders (e.g. `universal`).
#
#     Although Install Doctor comes with presets that install a whole gigantic amount of software, it can actually
#     be quite good at provisioning minimal server environments where you want to keep the binaries to a minimum.
#
#     ## Environment Variables
#
#     Specify certain environment variables to customize the behavior of Install Doctor. With the right combination of
#     environment variables, this script can be run completely headlessly (no interactive prompts). This allows
#     automated testing across a wide variety of operating systems.
#
#     | Variable                  | Description                                                                       |
#     |---------------------------|-----------------------------------------------------------------------------------|
#     | `START_REPO` (or `REPO`)  | Git fork URL or GitHub user/repo shorthand to use when provisioning               |
#     | `ANSIBLE_PROVISION_VM`    | **For Qubes**, determines the name of the VM used to provision the system         |
#     | `DEBUG_MODE` (or `DEBUG`) | Set to `true` to enable verbose logging                                           |
#     | `HEADLESS_INSTALL`        | Set to `true` to skip all interactive prompts and use defaults                    |
#     | `SOFTWARE_GROUP`          | Software group to install: "Basic", "Server", "Standard", or "Full" (default)    |
#     | `SUDO_PASSWORD`           | Sudo password for automated passwordless sudo setup                               |
#     | `CI` or `TEST_INSTALL`    | Set either to enable CI mode with predefined defaults                             |
#     | `NO_RESTART`              | Set to `true` to prevent automatic reboots                                        |
#     | `FULL_NAME`               | User's full name for git and other configurations                                 |
#     | `PRIMARY_EMAIL`           | User's primary email address                                                      |
#     | `KEEP_GOING`              | Set to `true` to continue provisioning even if errors occur                       |
#
#     ### Fully Headless Installation
#
#     To run the installer with zero interactive prompts:
#
#     ```bash
#     HEADLESS_INSTALL=true SOFTWARE_GROUP=Full SUDO_PASSWORD=your_password \
#       bash <(curl -sSL https://install.doctor/start)
#     ```
#
#     For a full list of variables you can use to customize Install Doctor, check out our [Customization](https://install.doctor/docs/customization)
#     and [Secrets](https://install.doctor/docs/customization/secrets) documentation.
#
#     ## Supported Platforms
#
#     | Platform       | Status       | Notes                                           |
#     |----------------|--------------|-------------------------------------------------|
#     | macOS          | Supported    | Intel and Apple Silicon (Rosetta 2 auto-installed)|
#     | Ubuntu/Debian  | Supported    | Tested on latest LTS releases                    |
#     | Fedora/RHEL    | Supported    | Tested on latest releases                        |
#     | Archlinux      | Supported    | Tested on rolling release                        |
#     | CentOS         | Supported    | Via yum/dnf                                      |
#     | OpenSUSE       | Supported    | Via zypper                                       |
#     | Alpine         | Supported    | Via apk                                          |
#     | Qubes OS       | In Progress  | Dom0 and AppVM provisioning                      |
#     | Windows        | Roadmap      | Planned via WSL                                  |
#     | FreeBSD        | Roadmap      | Not yet implemented                              |
#
#     ## Links
#
#     [Install Doctor homepage](https://install.doctor)
#     [Install Doctor documentation portal](https://install.doctor/docs) (includes tips, tricks, and guides on how to customize the system to your liking)

# @description This function logs with style using Gum if it is installed, otherwise it uses `echo`. It is also capable of leveraging Glow to render markdown.
#     When Glow is not installed, it uses `cat`. The following sub-commands are available:
#
#     | Sub-Command | Description                                                                                         |
#     |-------------|-----------------------------------------------------------------------------------------------------|
#     | `error`     | Logs a bright red error message                                                                     |
#     | `info`      | Logs a regular informational message                                                                |
#     | `md`        | Tries to render the specified file using `glow` if it is installed and uses `cat` as a fallback     |
#     | `prompt`    | Alternative that logs a message intended to describe an upcoming user input prompt                  |
#     | `star`      | Alternative that logs a message that starts with a star icon                                        |
#     | `start`     | Same as `success`                                                                                   |
#     | `success`   | Logs a success message that starts with green checkmark                                             |
#     | `warn`      | Logs a bright yellow warning message                                                                |
logg() {
  TYPE="$1"
  MSG="$2"
  if [ "$TYPE" == 'error' ]; then
    if command -v gum > /dev/null; then
        gum style --border="thick" "$(gum style --foreground="#ff0000" "✖") $(gum style --bold --background="#ff0000" --foreground="#ffffff"  " ERROR ") $(gum style --bold "$MSG")"
    else
        echo "ERROR: $MSG"
    fi
  elif [ "$TYPE" == 'info' ]; then
    if command -v gum > /dev/null; then
        gum style " $(gum style --foreground="#00ffff" "○") $(gum style --faint "$MSG")"
    else
        echo "INFO: $MSG"
    fi
  elif [ "$TYPE" == 'md' ]; then
    if command -v glow > /dev/null; then
        glow "$MSG"
    else
        cat "$MSG"
    fi
  elif [ "$TYPE" == 'prompt' ]; then
    if command -v gum > /dev/null; then
        gum style " $(gum style --foreground="#00008b" "▶") $(gum style --bold "$MSG")"
    else
        echo "PROMPT: $MSG"
    fi
  elif [ "$TYPE" == 'star' ]; then
    if command -v gum > /dev/null; then
        gum style " $(gum style --foreground="#d1d100" "◆") $(gum style --bold "$MSG")"
    else
        echo "STAR: $MSG"
    fi
  elif [ "$TYPE" == 'start' ]; then
    if command -v gum > /dev/null; then
        gum style " $(gum style --foreground="#00ff00" "▶") $(gum style --bold "$MSG")"
    else
        echo "START: $MSG"
    fi
  elif [ "$TYPE" == 'success' ]; then
    if command -v gum > /dev/null; then
        gum style " $(gum style --foreground="#00ff00" "✔") $(gum style --bold "$MSG")"
    else
        echo "SUCCESS: $MSG"
    fi
  elif [ "$TYPE" == 'warn' ]; then
    if command -v gum > /dev/null; then
        gum style " $(gum style --foreground="#d1d100" "◆") $(gum style --bold --background="#ffff00" --foreground="#000000"  " WARNING ") $(gum style --bold "$MSG")"
    else
        echo "WARNING: $MSG"
    fi
  else
    if command -v gum > /dev/null; then
        gum style " $(gum style --foreground="#00ff00" "▶") $(gum style --bold "$TYPE")"
    else
        echo "$MSG"
    fi
  fi
}

# @description Cleanup function to ensure temporary passwordless sudo is removed on exit or interruption.
#     Uses direct sed instead of removePasswordlessSudo() to avoid dependency on functions/tools that may
#     not be available during early failures.
cleanup() {
  if grep -q '# TEMPORARY FOR INSTALL DOCTOR' /etc/sudoers 2>/dev/null; then
    if command -v gsed > /dev/null; then
      sudo gsed -i '/# TEMPORARY FOR INSTALL DOCTOR/d' /etc/sudoers 2>/dev/null || true
    elif [[ "$OSTYPE" == 'darwin'* ]]; then
      sudo sed -i '' '/# TEMPORARY FOR INSTALL DOCTOR/d' /etc/sudoers 2>/dev/null || true
    else
      sudo sed -i '/# TEMPORARY FOR INSTALL DOCTOR/d' /etc/sudoers 2>/dev/null || true
    fi
  fi
  if [ -f "$HOME/.zshrc" ] && grep -q '# TEMPORARY FOR INSTALL DOCTOR MACOS' "$HOME/.zshrc" 2>/dev/null; then
    if command -v gsed > /dev/null; then
      gsed -i '/# TEMPORARY FOR INSTALL DOCTOR MACOS/d' "$HOME/.zshrc" 2>/dev/null || true
    elif [[ "$OSTYPE" == 'darwin'* ]]; then
      sed -i '' '/# TEMPORARY FOR INSTALL DOCTOR MACOS/d' "$HOME/.zshrc" 2>/dev/null || true
    else
      sed -i '/# TEMPORARY FOR INSTALL DOCTOR MACOS/d' "$HOME/.zshrc" 2>/dev/null || true
    fi
  fi
}
trap cleanup EXIT INT TERM

# @description Sets core environment variables for the provisioning process.
#     - Sets `DEBIAN_FRONTEND=noninteractive` to prevent apt-get from prompting during package installation
#     - Sets `HOMEBREW_NO_ENV_HINTS=true` to suppress Homebrew hint messages
#     - Determines the `START_REPO` git URL based on user input:
#       - If `START_REPO` and `REPO` are both unset, defaults to the official Install Doctor repository
#       - If `REPO` is set but `START_REPO` is not, copies `REPO` to `START_REPO`
#       - Supports shorthand formats: `user/repo` expands to `https://github.com/user/repo.git`
#       - Supports bare username format: `user` expands to `https://github.com/user/install.doctor.git`
#       - Full git URLs (containing `://` or `:`) are used as-is
#
#     @envvar START_REPO  The git repository URL to clone for provisioning
#     @envvar REPO  Alternative to START_REPO (START_REPO takes precedence)
setEnvironmentVariables() {
  export DEBIAN_FRONTEND=noninteractive
  export HOMEBREW_NO_ENV_HINTS=true
  if [ -z "$START_REPO" ] && [ -z "$REPO" ]; then
    export START_REPO="https://github.com/megabyte-labs/install.doctor.git"
  else
    if [ -n "$REPO" ] && [ -z "$START_REPO" ]; then
      export START_REPO="$REPO"
    fi
    if [[ "$START_REPO" == *"/"* ]]; then
      # Either full git address or GitHubUser/RepoName
      if [[ "$START_REPO" == *":"* ]] || [[ "$START_REPO" == *"//"* ]]; then
        export START_REPO="$START_REPO"
      else
        export START_REPO="https://github.com/${START_REPO}.git"
      fi
    else
      export START_REPO="https://github.com/$START_REPO/install.doctor.git"
    fi
  fi
}

# @description Ensures essential system dependencies are installed using the platform's native package manager.
#     This function detects the operating system and installs the following packages if missing:
#
#     - `curl` - HTTP client for downloading files
#     - `git` - Version control system
#     - `expect` / `unbuffer` - Terminal automation utilities
#     - `rsync` - File synchronization tool
#     - `file` - File type detection utility
#     - `procps` / `procps-ng` - Process utilities (ps, top, etc.)
#     - `moreutils` - Additional Unix utilities (ts, sponge, etc.)
#     - Build tools (`build-essential`, `base-devel`, etc.)
#
#     On macOS, this function also ensures:
#     - Xcode Command Line Tools are installed (via `softwareupdate`)
#     - Rosetta 2 is installed on Apple Silicon Macs
#
#     Supported package managers: apt-get, dnf, yum, pacman, zypper, apk, choco (Windows)
ensureBasicDeps() {
  if ! command -v curl > /dev/null || ! command -v git > /dev/null || ! command -v expect > /dev/null || ! command -v rsync > /dev/null || ! command -v unbuffer > /dev/null; then
    if command -v apt-get > /dev/null; then
      ### Debian / Ubuntu
      logg info 'Running sudo apt-get update' && sudo apt-get update
      logg info 'Running sudo apt-get install -y build-essential curl expect git moreutils rsync procps file' && sudo apt-get install -y build-essential curl expect git moreutils rsync procps file
    elif command -v dnf > /dev/null; then
      ### Fedora
      logg info 'Running sudo dnf groupinstall -y "Development Tools"' && sudo dnf groupinstall -y 'Development Tools'
      logg info 'Running sudo dnf install -y curl expect git moreutils rsync procps-ng file' && sudo dnf install -y curl expect git moreutils rsync procps-ng file
    elif command -v yum > /dev/null; then
      ### CentOS
      logg info 'Running sudo yum groupinstall -y "Development Tools"' && sudo yum groupinstall -y 'Development Tools'
      logg info 'Running sudo yum install -y curl expect git moreutils rsync procps-ng file' && sudo yum install -y curl expect git moreutils rsync procps-ng file
    elif command -v pacman > /dev/null; then
      ### Archlinux
      logg info 'Running sudo pacman -Sy --noconfirm' && sudo pacman -Sy --noconfirm
      logg info 'Running sudo pacman -Syu --noconfirm base-devel curl expect git moreutils rsync procps-ng file' && sudo pacman -Syu --noconfirm base-devel curl expect git moreutils rsync procps-ng file
    elif command -v zypper > /dev/null; then
      ### OpenSUSE
      logg info 'Running sudo zypper install -yt pattern devel_basis' && sudo zypper install -yt pattern devel_basis
      logg info 'Running sudo zypper install -y curl expect git moreutils rsync procps file' && sudo zypper install -y curl expect git moreutils rsync procps file
    elif command -v apk > /dev/null; then
      ### Alpine
      logg info 'Running sudo apk add build-base curl expect git moreutils rsync ruby procps file' && sudo apk add build-base curl expect git moreutils rsync ruby procps file
    elif [ -d /Applications ] && [ -d /Library ]; then
      ### macOS
      logg info "Ensuring Xcode Command Line Tools are installed.."
      if ! xcode-select -p >/dev/null 2>&1; then
        logg info "Command Line Tools for Xcode not found"
        ### This temporary file prompts the 'softwareupdate' utility to list the Command Line Tools
        touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
        XCODE_PKG="$(softwareupdate -l | grep "\*.*Command Line" | tail -n 1 | sed 's/^[^C]* //')"
        logg info "Installing from softwareupdate" && softwareupdate -i "$XCODE_PKG" && logg info "Successfully installed $XCODE_PKG"
        if command -v xcodebuild > /dev/null; then
          logg info 'Running xcodebuild -license accept'
          sudo xcodebuild -license accept
          logg info 'Running sudo xcodebuild -runFirstLaunch'
          sudo xcodebuild -runFirstLaunch
        else
          logg warn 'xcodebuild is not available'
        fi
      fi
      if /usr/bin/pgrep -q oahd; then
        logg info 'Rosetta 2 is already installed'
      else
        logg info 'Ensuring Rosetta 2 is installed' && softwareupdate --install-rosetta --agree-to-license
      fi
    elif [[ "$OSTYPE" == 'cygwin' ]] || [[ "$OSTYPE" == 'msys' ]] || [[ "$OSTYPE" == 'win32' ]]; then
      ### Windows
      logg info 'Running choco install -y curl expect git moreutils rsync' && choco install -y curl expect git moreutils rsync
    elif command -v nix-env > /dev/null; then
      ### NixOS
      logg warn "TODO - Add support for NixOS"
    elif [[ "$OSTYPE" == 'freebsd'* ]]; then
      ### FreeBSD
      logg warn "TODO - Add support for FreeBSD"
    elif command -v pkg > /dev/null; then
      ### Termux
      logg warn "TODO - Add support for Termux"
    elif command -v xbps-install > /dev/null; then
      ### Void
      logg warn "TODO - Add support for Void"
    fi
  fi
}

### Ensure Homebrew is loaded
loadHomebrew() {
  if ! command -v brew > /dev/null; then
    if [ -f /usr/local/bin/brew ]; then
      logg info "Using /usr/local/bin/brew" && eval "$(/usr/local/bin/brew shellenv)"
    elif [ -f "${HOMEBREW_PREFIX:-/opt/homebrew}/bin/brew" ]; then
      logg info "Using ${HOMEBREW_PREFIX:-/opt/homebrew}/bin/brew" && eval "$("${HOMEBREW_PREFIX:-/opt/homebrew}/bin/brew" shellenv)"
    elif [ -d "$HOME/.linuxbrew" ]; then
      logg info "Using $HOME/.linuxbrew/bin/brew" && eval "$("$HOME/.linuxbrew/bin/brew" shellenv)"
    elif [ -d "/home/linuxbrew/.linuxbrew" ]; then
      logg info 'Using /home/linuxbrew/.linuxbrew/bin/brew' && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    else
      logg info 'Could not find Homebrew installation'
    fi
  fi
}

### Ensures Homebrew folders have proper owners / permissions
fixHomebrewPermissions() {
  if command -v brew > /dev/null; then
    logg info 'Applying proper permissions on Homebrew folders'
    sudo chmod -R go-w "$(brew --prefix)/share"
    BREW_DIRS="share etc/bash_completion.d"
    for BREW_DIR in $BREW_DIRS; do
      if [ -d "$(brew --prefix)/$BREW_DIR" ]; then
        sudo chown -Rf "$(whoami)" "$(brew --prefix)/$BREW_DIR"
      fi
    done
    logg info 'Running brew update --force --quiet' && brew update --force --quiet
  fi
}

# @description This function removes group write permissions from the Homebrew share folder which
#     is required for the ZSH configuration.
fixHomebrewSharePermissions() {
  if [ -f /usr/local/bin/brew ]; then
    sudo chmod -R g-w /usr/local/share
  elif [ -f "${HOMEBREW_PREFIX:-/opt/homebrew}/bin/brew" ]; then
    sudo chmod -R g-w "${HOMEBREW_PREFIX:-/opt/homebrew}/share"
  elif [ -d "$HOME/.linuxbrew" ]; then
    sudo chmod -R g-w "$HOME/.linuxbrew/share"
  elif [ -d "/home/linuxbrew/.linuxbrew" ]; then
    sudo chmod -R g-w /home/linuxbrew/.linuxbrew/share
  fi
}

### Installs Homebrew
ensurePackageManagerHomebrew() {
  if ! command -v brew > /dev/null; then
    ### Select install type based off of whether or not sudo privileges are available
    if command -v sudo > /dev/null && sudo -n true; then
      logg info 'Installing Homebrew. Sudo privileges available.'
      echo | bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || BREW_EXIT_CODE="$?"
      if [ -d "/opt/homebrew" ]; then
        logg info "Setting owner of /opt/homebrew to '$(whoami)'" && sudo chown -R "$(whoami)" /opt/homebrew || logg warn "Failed to chown /opt/homebrew to '$(whoami)'"
      fi
      fixHomebrewSharePermissions
    else
      logg info 'Installing Homebrew. Sudo privileges not available. Password may be required.'
      echo | bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || BREW_EXIT_CODE="$?"
      if [ -d "/opt/homebrew" ]; then
        logg info "Setting owner of /opt/homebrew to '$(whoami)'" && sudo chown -R "$(whoami)" /opt/homebrew || logg warn "Failed to chown /opt/homebrew to '$(whoami)'"
      fi
      fixHomebrewSharePermissions
    fi

    ### Attempt to fix problematic installs
    if [ -n "$BREW_EXIT_CODE" ]; then
        logg warn 'Homebrew was installed but part of the installation failed to complete successfully.'
        fixHomebrewPermissions
      fi
  fi
}

### Ensures gcc is installed
ensureGcc() {
  if command -v brew > /dev/null; then
    if ! brew list | grep gcc > /dev/null; then
      logg info 'Installing Homebrew gcc' && brew install --quiet gcc
    else
      logg info 'Homebrew gcc is available'
    fi
  else
    logg error 'Failed to initialize Homebrew' && exit 1
  fi
}

# @description This function ensures Homebrew is installed and available in the `PATH`. It handles the installation of Homebrew on both **Linux and macOS**.
#     It will attempt to bypass sudo password entry if it detects that it can do so. The function also has some error handling in regards to various
#     directories falling out of the correct ownership and permission states. Finally, it loads Homebrew into the active profile (allowing other parts of the script
#     to use the `brew` command).
#
#     With Homebrew installed and available, the script finishes by installing the `gcc` Homebrew package which is a very common dependency.
ensureHomebrew() {
  loadHomebrew
  ensurePackageManagerHomebrew
  loadHomebrew
  ensureGcc
}

# @description This function determines whether or not a reboot is required on the target system.
#     On Linux, it will check for the presence of the `/var/run/reboot-required` file to determine
#     whether or not a reboot is required. On macOS, it will read `/Library/Updates/index.plist`
#     to determine whether or not a reboot is required.
#
#     After determining whether or not a reboot is required, the script will attempt to automatically
#     reboot the machine.
handleRequiredReboot() {
  if [ -n "$NO_RESTART" ]; then
    logg info 'NO_RESTART is set — skipping reboot check'
    return 0
  fi
  if [ -d /Applications ] && [ -d /System ]; then
    ### macOS
    if ! defaults read /Library/Updates/index.plist InstallAtLogout 2>&1 | grep 'does not exist' > /dev/null; then
      logg info 'There appears to be an update that requires a reboot'
      logg info 'Attempting to reboot gracefully' && osascript -e 'tell application "Finder" to shut down'
    fi
  elif [ -f /var/run/reboot-required ]; then
    ### Linux
    logg info '/var/run/reboot-required is present so a reboot is required'
    if command -v systemctl > /dev/null; then
      logg info 'systemctl present so rebooting with sudo systemctl start reboot.target' && sudo systemctl start reboot.target
    elif command -v reboot > /dev/null; then
      logg info 'reboot available as command so rebooting with sudo reboot' && sudo reboot
    elif command -v shutdown > /dev/null; then
      logg info 'shutdown command available so rebooting with sudo shutdown -r now' && sudo shutdown -r now
    else
      logg warn 'Reboot required but unable to determine appropriate restart command'
    fi
  fi
}
# @description Prints information describing why full disk access is required for the script to run on macOS.
printFullDiskAccessNotice() {
  if [ -d /Applications ] && [ -d /System ]; then
    logg md "${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/docs/terminal/full-disk-access.md"
  fi
}

# @description Ensures the terminal running the provisioning process has full disk access on macOS.
#     Full disk access is required to modify system files, preferences, and permissions during provisioning.
#
#     This function works by attempting to read a file (`com.apple.TimeMachine.plist`) that requires
#     full disk access. If the read fails, it means the terminal lacks the permission.
#
#     **Behavior when full disk access is missing:**
#     - In headless mode (`HEADLESS_INSTALL=true`): Logs a warning and continues (some operations may fail)
#     - In interactive mode: Opens the macOS System Preferences pane and exits so the user can grant access
#
#     After granting access, the user must restart the terminal. A temporary entry is added to `~/.zshrc`
#     to automatically re-run the install script on the next terminal launch.
#
#     @envvar HEADLESS_INSTALL  If set, skips the interactive full disk access prompt
#     @see [Detecting Full Disk Access on macOS](https://www.dzombak.com/blog/2021/11/macOS-Scripting-How-to-tell-if-the-Terminal-app-has-Full-Disk-Access.html)
ensureFullDiskAccess() {
  if [ -d /Applications ] && [ -d /System ]; then
    if ! plutil -lint /Library/Preferences/com.apple.TimeMachine.plist > /dev/null ; then
      if [ -n "$HEADLESS_INSTALL" ]; then
        logg warn 'Full disk access is not available. Some macOS operations may fail in headless mode.'
        return 0
      fi
      printFullDiskAccessNotice
      logg star 'Opening Full Disk Access preference pane.. Grant full-disk access for the terminal you would like to run the provisioning process with.' && open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"
      logg info 'You may have to force quit the terminal and have it reload.'
      if [ ! -f "$HOME/.zshrc" ] || ! grep -q '# TEMPORARY FOR INSTALL DOCTOR MACOS' "$HOME/.zshrc"; then
        echo 'bash <(curl -sSL https://install.doctor/start) # TEMPORARY FOR INSTALL DOCTOR MACOS' >> "$HOME/.zshrc"
      fi
      exit 0
    else
      logg info 'Current terminal has full disk access'
      if [ -f "$HOME/.zshrc" ]; then
        if command -v gsed > /dev/null; then
          gsed -i '/# TEMPORARY FOR INSTALL DOCTOR MACOS/d' "$HOME/.zshrc" || logg warn "Failed to remove kickstart script from .zshrc"
        else
          sed -i '' '/# TEMPORARY FOR INSTALL DOCTOR MACOS/d' "$HOME/.zshrc" || logg warn "Failed to remove kickstart script from .zshrc"
        fi
      fi
    fi
  fi
}

# @description Imports the CloudFlare Teams certificate into the macOS system keychain.
#     This is required for CloudFlare Zero Trust / WARP to function properly with HTTPS inspection.
#
#     **Conditions for execution:**
#     - Only runs on macOS (checks for `/Applications` and `/System` directories)
#     - Skipped entirely when `HEADLESS_INSTALL` is set (requires Touch ID / password prompt)
#     - Certificate must exist at `$HOME/.local/etc/ssl/cloudflare/cloudflare.crt`
#
#     @envvar HEADLESS_INSTALL  If set, skips certificate import (requires user interaction on macOS)
importCloudFlareCert() {
  if [ -d /Applications ] && [ -d /System ] && [ -z "$HEADLESS_INSTALL" ]; then
    ### Acquire certificate
    if [ -f "$HOME/.local/etc/ssl/cloudflare/cloudflare.crt" ]; then
      CRT_TMP="$HOME/.local/etc/ssl/cloudflare/cloudflare.crt"
      ### Validate / import certificate
      security verify-cert -c "$CRT_TMP" > /dev/null 2>&1
      if [ $? -ne 0 ]; then
        logg info '**macOS Manual Security Permission** Requesting security authorization for Cloudflare trusted certificate'
        sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain "$CRT_TMP" && logg info 'Successfully imported cloudflare.crt into System.keychain'
      fi
    else
      logg warn "$HOME/.local/etc/ssl/cloudflare/cloudflare.crt is missing"
    fi
  fi
}


# @description Applies default environment variable settings when running in a CI/CD environment.
#     This function is triggered when either the `CI` or `TEST_INSTALL` environment variable is set.
#     It configures the provisioning process for unattended, headless operation with sensible defaults.
#
#     The following defaults are applied:
#     - `NO_RESTART=true` - Prevents automatic reboots during provisioning
#     - `HEADLESS_INSTALL=true` - Disables all interactive prompts
#     - `SOFTWARE_GROUP=Full-Desktop` - Installs the full desktop software suite
#     - Various identity variables are set to default values for testing
#
#     @envvar CI  Set by most CI/CD platforms (GitHub Actions, GitLab CI, etc.)
#     @envvar TEST_INSTALL  Alternative flag for triggering CI mode manually
setCIEnvironmentVariables() {
  if [ -n "$CI" ] || [ -n "$TEST_INSTALL" ]; then
    logg info "Automatically setting environment variables for CI/headless mode"
    export NO_RESTART=true
    export HEADLESS_INSTALL=true
    export SOFTWARE_GROUP="${SOFTWARE_GROUP:-Full-Desktop}"
    export FULL_NAME="${FULL_NAME:-Brian Zalewski}"
    export PRIMARY_EMAIL="${PRIMARY_EMAIL:-brian@megabyte.space}"
    export PUBLIC_SERVICES_DOMAIN="${PUBLIC_SERVICES_DOMAIN:-lab.megabyte.space}"
    export RESTRICTED_ENVIRONMENT="${RESTRICTED_ENVIRONMENT:-false}"
    export WORK_ENVIRONMENT="${WORK_ENVIRONMENT:-false}"
    export HOST="${HOST:-$(hostname -s)}"
    logg info "CI environment configured: SOFTWARE_GROUP=$SOFTWARE_GROUP, HEADLESS_INSTALL=$HEADLESS_INSTALL"
  fi
}

# @description Disconnect from WARP if connected. Skipped in debug mode to allow debugging with WARP active.
ensureWarpDisconnected() {
  if [ -n "$DEBUG_MODE" ] || [ -n "$DEBUG" ]; then
    logg info 'Skipping WARP disconnect in debug mode'
    return 0
  fi
  if command -v warp-cli > /dev/null; then
    if warp-cli status | grep 'Connected' > /dev/null; then
      logg info "Disconnecting from WARP" && warp-cli disconnect && logg info "Disconnected WARP to prevent conflicts"
    fi
  fi
}

# @description Temporarily grants the current user passwordless sudo for the duration of the provisioning process.
#     This function will:
#     1. Check if passwordless sudo is already available
#     2. Try to decrypt the SUDO_PASSWORD from Chezmoi secrets if available
#     3. Use the SUDO_PASSWORD environment variable if set
#     4. Fall back to prompting the user with a 30-second timeout (auto-proceeds on timeout)
#
#     The passwordless sudo entry is marked with a comment so it can be removed later by `removePasswordlessSudo()`.
#
#     @envvar SUDO_PASSWORD  If set, used to authenticate sudo without interactive prompts
#     @envvar HEADLESS_INSTALL  If set, skips interactive prompts entirely
setupPasswordlessSudo() {
  sudo -n true || SUDO_EXIT_CODE=$?
  if [ -z "$SUDO_EXIT_CODE" ]; then
    logg info 'Passwordless sudo is already available'
    return 0
  fi
  logg info 'Your user will temporarily be granted passwordless sudo for the duration of the script'
  if [ -n "$SUDO_EXIT_CODE" ] && [ -z "$SUDO_PASSWORD" ] && command -v chezmoi > /dev/null && [ -f "${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/home/.chezmoitemplates/secrets-$(hostname -s)/SUDO_PASSWORD" ] && [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/age/chezmoi.txt" ]; then
    logg info "Acquiring SUDO_PASSWORD by using Chezmoi to decrypt ${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/home/.chezmoitemplates/secrets-$(hostname -s)/SUDO_PASSWORD"
    SUDO_PASSWORD="$(cat "${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/home/.chezmoitemplates/secrets-$(hostname -s)/SUDO_PASSWORD" | chezmoi decrypt)"
    export SUDO_PASSWORD
  fi
  SUDOERS_ENTRY="$(whoami) ALL=(ALL:ALL) NOPASSWD: ALL # TEMPORARY FOR INSTALL DOCTOR"
  if [ -n "$SUDO_PASSWORD" ]; then
    logg info 'Using the acquired sudo password to automatically grant the user passwordless sudo privileges for the duration of the script'
    printf '%s\n' "$SUDO_PASSWORD" | sudo -S -- sh -c 'echo "$1" >> /etc/sudoers' _ "$SUDOERS_ENTRY"
  else
    if [ -n "$HEADLESS_INSTALL" ]; then
      logg warn 'HEADLESS_INSTALL is set but no SUDO_PASSWORD is available. Attempting to continue without passwordless sudo.'
      return 0
    fi
    logg info 'Sudo password required. You have 30 seconds to enter your password (auto-skips on timeout).'
    logg info 'To bypass this prompt, set the SUDO_PASSWORD environment variable or use HEADLESS_INSTALL=true.'
    if timeout 30 sudo -- sh -c 'echo "$1" >> /etc/sudoers' _ "$SUDOERS_ENTRY" 2>/dev/null; then
      logg success 'Passwordless sudo granted successfully'
    else
      logg warn 'Sudo prompt timed out or failed. Continuing without passwordless sudo - some operations may prompt for a password.'
    fi
  fi
}

# @description Automates the Qubes sys-whonix Anon Connection Wizard by detecting the window and sending keystrokes.
#     Retries up to 4 times if the wizard window is not found.
CONFIG_WIZARD_COUNT=0
configureWizard() {
  if xwininfo -root -tree | grep "Anon Connection Wizard"; then
    WINDOW_ID="$(xwininfo -root -tree | grep "Anon Connection Wizard" | sed 's/^ *\([^ ]*\) .*/\1/')"
    xdotool windowactivate "$WINDOW_ID" && sleep 1 && xdotool key 'Enter' && sleep 1 && xdotool key 'Tab Tab Enter' && sleep 24 && xdotool windowactivate "$WINDOW_ID" && sleep 1 && xdotool key 'Enter' && sleep 300
    qvm-shutdown --wait sys-whonix
    sleep 3
    qvm-start sys-whonix
    if xwininfo -root -tree | grep "systemcheck | Whonix" > /dev/null; then
      WINDOW_ID_SYS_CHECK="$(xwininfo -root -tree | grep "systemcheck | Whonix" | sed 's/^ *\([^ ]*\) .*/\1/')"
      if xdotool windowactivate "$WINDOW_ID_SYS_CHECK"; then
        sleep 1
        xdotool key 'Enter'
      fi
    fi
  else
    sleep 3
    CONFIG_WIZARD_COUNT=$((CONFIG_WIZARD_COUNT + 1))
    if [[ "$CONFIG_WIZARD_COUNT" == '4' ]]; then
      echo "The sys-whonix anon-connection-wizard utility did not open."
    else
      echo "Checking for anon-connection-wizard again.."
      configureWizard
    fi
  fi
}

# @description Ensure sys-whonix is configured (for Qubes dom0)
ensureSysWhonix() {
  CONFIG_WIZARD_COUNT=0
}

# @description Ensure dom0 is updated
ensureDom0Updated() {
  if [ ! -f /root/dom0-updated ]; then
    sudo qubesctl --show-output state.sls update.qubes-dom0
    sudo qubes-dom0-update --clean -y
    touch /root/dom0-updated
  fi
}

# @description Ensure sys-whonix is running
ensureSysWhonixRunning() {
  if ! qvm-check --running sys-whonix; then
    qvm-start sys-whonix --skip-if-running
    configureWizard > /dev/null
  fi
}

# @description Ensure TemplateVMs are updated
ensureTemplateVMsUpdated() {
  if [ ! -f /root/templatevms-updated ]; then
    # timeout of 10 minutes is added here because the whonix-gw VM does not like to get updated
    # with this method. Anyone know how to fix this?
    sudo timeout 600 qubesctl --show-output --skip-dom0 --templates state.sls update.qubes-vm &> /dev/null || true
    while read -r RESTART_VM; do
      qvm-shutdown --wait "$RESTART_VM"
    done< <(qvm-ls --all --no-spinner --fields=name,state | grep Running | grep -v sys-net | grep -v sys-firewall | grep -v sys-whonix | grep -v dom0 | awk '{print $1}')
    sudo touch /root/templatevms-updated
  fi
}

# @description Ensure provisioning VM can run commands on any VM
ensureProvisioningVMPermissions() {
  echo "/bin/bash" | sudo tee /etc/qubes-rpc/qubes.VMShell
  sudo chmod 755 /etc/qubes-rpc/qubes.VMShell
  echo "${ANSIBLE_PROVISION_VM:=provision}"' dom0 allow' | sudo tee /etc/qubes-rpc/policy/qubes.VMShell
  echo "$ANSIBLE_PROVISION_VM"' $anyvm allow' | sudo tee -a /etc/qubes-rpc/policy/qubes.VMShell
  sudo chown "$(whoami):$(whoami)" /etc/qubes-rpc/policy/qubes.VMShell
  sudo chmod 644 /etc/qubes-rpc/policy/qubes.VMShell
}

# @description Create provisioning VM and initialize the provisioning process from there
createAndInitProvisionVM() {
  qvm-create --label red --template debian-11 "$ANSIBLE_PROVISION_VM" &> /dev/null || true
  qvm-volume extend "$ANSIBLE_PROVISION_VM:private" "40G"
  if [ -f ~/.vaultpass ]; then
    qvm-run "$ANSIBLE_PROVISION_VM" 'rm -f ~/QubesIncoming/dom0/.vaultpass'
    qvm-copy-to-vm "$ANSIBLE_PROVISION_VM" ~/.vaultpass
    qvm-run "$ANSIBLE_PROVISION_VM" 'cp ~/QubesIncoming/dom0/.vaultpass ~/.vaultpass'
  fi
}

# @description Restart the provisioning process with the same script but from the provisioning VM
runStartScriptInProvisionVM() {
  qvm-run --pass-io "$ANSIBLE_PROVISION_VM" 'curl -sSL https://install.doctor/start > ~/start.sh && bash ~/start.sh'
}

# @description Perform Qubes dom0 specific logic like updating system packages, setting up the Tor VM, updating TemplateVMs, and
#     beginning the provisioning process using Ansible and an AppVM used to handle the provisioning process
handleQubesDom0() {
  if command -v qubesctl > /dev/null; then
    ensureSysWhonix
    ensureDom0Updated
    ensureSysWhonixRunning
    ensureTemplateVMsUpdated
    ensureProvisioningVMPermissions
    createAndInitProvisionVM
    runStartScriptInProvisionVM
    exit 0
  fi
}

# @description Helper function used by [[ensureHomebrewDeps]] to ensure a Homebrew package is installed after
#     first checking if it is already available on the system.
installBrewPackage() {
  if ! command -v "$1" > /dev/null; then
    logg info 'Installing '"$1"''
    brew install --quiet "$1"
  fi
}

# @description Installs various dependencies using Homebrew.
#
#     1. Ensures Glow, Gum, Chezmoi, Node.js, and ZX are installed.
#     2. If the system is macOS, then also install `gsed` and `coreutils`.
ensureHomebrewDeps() {
  ### Base dependencies
  installBrewPackage "glow"
  installBrewPackage "gum"
  installBrewPackage "chezmoi"
  installBrewPackage "node"
  installBrewPackage "zx"

  ### macOS
  if [ -d /Applications ] && [ -d /System ]; then
    ### gsed
    installBrewPackage "gsed"
    ### unbuffer / expect
    if ! command -v unbuffer > /dev/null; then
      brew install --quiet expect
    fi
    ### gtimeout / coreutils
    if ! command -v gtimeout > /dev/null; then
      brew install --quiet coreutils
    fi
    ### ts / moreutils
    if ! command -v ts > /dev/null; then
      brew install --quiet moreutils
    fi
  fi
}

# @description Ensure the `${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi` directory is cloned and up-to-date using the previously
#     set `START_REPO` as the source repository.
cloneChezmoiSourceRepo() {
  ### Accept licenses (only necessary if other steps fail)
  if [ -d /Applications ] && [ -d /System ]; then
    if command -v xcodebuild > /dev/null; then
      logg info 'Running xcodebuild -license accept'
      sudo xcodebuild -license accept
      logg info 'Running sudo xcodebuild -runFirstLaunch'
      sudo xcodebuild -runFirstLaunch
    else
      logg warn 'xcodebuild is not available'
    fi
  fi

  CHEZMOI_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi"
  if [ -d "$CHEZMOI_DIR/.git" ]; then
    logg info "Updating existing repo at $CHEZMOI_DIR"
    git -C "$CHEZMOI_DIR" config http.postBuffer 524288000 2>/dev/null || true
    DEFAULT_BRANCH="$(git -C "$CHEZMOI_DIR" remote show origin 2>/dev/null | grep 'HEAD branch' | cut -d' ' -f5)"
    DEFAULT_BRANCH="${DEFAULT_BRANCH:-master}"
    logg info "Pulling the latest changes from $DEFAULT_BRANCH" && git -C "$CHEZMOI_DIR" pull origin "$DEFAULT_BRANCH" || logg warn "git pull failed — continuing with existing checkout"
  else
    logg info "Ensuring ${XDG_DATA_HOME:-$HOME/.local/share} is a folder" && mkdir -p "${XDG_DATA_HOME:-$HOME/.local/share}"
    logg info "Cloning ${START_REPO} to $CHEZMOI_DIR" && git clone "${START_REPO}" "$CHEZMOI_DIR"
    git -C "$CHEZMOI_DIR" config http.postBuffer 524288000
  fi
}

# @description Guide the user through the initial setup by showing TUI introduction and accepting input through various prompts.
#     This function performs three main steps:
#
#     1. **Introduction Display**: Shows `chezmoi-intro.md` with `glow` (non-blocking, informational only)
#     2. **Software Group Selection**: Prompts for the software group if `SOFTWARE_GROUP` is not defined.
#        Currently defaults to "Full" (other groups like "Basic", "Server", "Standard" are planned).
#        To skip the prompt entirely, set `SOFTWARE_GROUP` before running the script.
#     3. **Chezmoi Initialization**: Runs `chezmoi init` when the Chezmoi configuration file is missing.
#        In headless mode (`HEADLESS_INSTALL=true`), this uses the `--force` flag to skip interactive prompts.
#
#     @envvar SOFTWARE_GROUP  Pre-set to skip the software group selection prompt (default: "Full")
#     @envvar HEADLESS_INSTALL  If set, forces chezmoi init to run non-interactively
initChezmoiAndPrompt() {
  ### Show `chezmoi-intro.md` with `glow` (non-blocking)
  if command -v glow > /dev/null; then
    glow "${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/docs/terminal/chezmoi-intro.md"
  fi

  ### Set the software group - defaults to "Full" if not specified
  if [ -z "$SOFTWARE_GROUP" ]; then
    SOFTWARE_GROUP="Full"
    export SOFTWARE_GROUP
  fi
  logg info "Software group set to: $SOFTWARE_GROUP"

  ### Ensure gum is available (used for TUI prompts elsewhere)
  if ! command -v gum > /dev/null; then
    logg warn 'Gum is not installed. Attempting to install via Homebrew.'
    if command -v brew > /dev/null; then
      brew install --quiet gum || logg warn 'Failed to install gum via Homebrew'
    else
      logg warn 'Homebrew is not available. Some interactive features may be unavailable.'
    fi
  fi

  if [ ! -f "${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/chezmoi.yaml" ]; then
    ### Run `chezmoi init` when the Chezmoi configuration is missing
    logg info "Running chezmoi init since ${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/chezmoi.yaml is not present"
    if [ -n "$HEADLESS_INSTALL" ]; then
      chezmoi init --force
    else
      chezmoi init
    fi
  fi
}

# @description When a reboot is triggered by softwareupdate on macOS, other utilities that require
#     a reboot are also installed to save on reboots.
beforeRebootDarwin() {
  logg info "Ensuring macfuse is installed" && brew install --cask --no-quarantine --quiet macfuse
}

# @description Runs `chezmoi apply` with appropriate flags and logging.
#     - Logs output to `$HOME/.local/var/log/install.doctor/chezmoi-apply-<timestamp>.log`
#     - Adds the `--force` flag when `HEADLESS_INSTALL` is set (skips all chezmoi prompts)
#     - Adds `-k` (keep going) flag to continue on errors
#     - Adds debug flags (`-vvv --debug --verbose`) when `DEBUG_MODE` or `DEBUG` is set
#     - On macOS, uses `caffeinate` to prevent system sleep during provisioning
#     - Uses `unbuffer` when available for cleaner log output
#     - Handles macOS-specific exit code 140 (reboot required for system updates)
#
#     @envvar HEADLESS_INSTALL  If set, adds --force flag to chezmoi apply
#     @envvar KEEP_GOING  If set, adds -k flag to continue past errors
#     @envvar DEBUG_MODE  If set, enables verbose debug output
#     @envvar DEBUG  Alternative to DEBUG_MODE
runChezmoi() {
  ### Set up logging
  mkdir -p "$HOME/.local/var/log/install.doctor"
  LOG_FILE="$HOME/.local/var/log/install.doctor/chezmoi-apply-$(date +%s).log"

  ### Apply command flags
  COMMON_MODIFIERS="--no-pager"
  FORCE_MODIFIER=""
  if [ -n "$HEADLESS_INSTALL" ]; then
    logg info 'Running chezmoi apply forcefully because HEADLESS_INSTALL is set'
    FORCE_MODIFIER="--force"
  fi
  # TODO: https://github.com/twpayne/chezmoi/discussions/3448
  KEEP_GOING_MODIFIER=""
  if [ -n "$KEEP_GOING" ]; then
    logg info 'Instructing chezmoi to keep going in the case of errors because KEEP_GOING is set'
    KEEP_GOING_MODIFIER="-k"
  fi
  DEBUG_MODIFIER=""
  if [ -n "$DEBUG_MODE" ] || [ -n "$DEBUG" ]; then
    logg info "Either DEBUG_MODE or DEBUG environment variables were set so Chezmoi will be run in debug mode"
    export DEBUG_MODIFIER="-vvv --debug --verbose"
  fi

  ### Run chezmoi apply — determine if we have a display AND a tty for tee
  HAS_DISPLAY=false
  if [ -t 1 ] && [ -e /dev/tty ]; then
    if [ -d /System ] && [ -d /Applications ]; then
      # macOS: Check if display information is available
      if system_profiler SPDisplaysDataType > /dev/null 2>&1; then
        HAS_DISPLAY=true
      fi
    else
      # Linux: Check if xrandr can list monitors
      if xrandr --listmonitors > /dev/null 2>&1; then
        HAS_DISPLAY=true
      fi
    fi
  fi

  # Build the command prefix array based on available tools
  CMD_PREFIX=()
  if [ "$HAS_DISPLAY" = "true" ] && command -v unbuffer > /dev/null; then
    CMD_PREFIX+=(unbuffer -p)
  fi
  if [ "$HAS_DISPLAY" = "true" ] && command -v caffeinate > /dev/null; then
    CMD_PREFIX+=(caffeinate)
  fi

  CHEZMOI_CMD=("${CMD_PREFIX[@]}" chezmoi apply $COMMON_MODIFIERS $DEBUG_MODIFIER $KEEP_GOING_MODIFIER $FORCE_MODIFIER)

  if [ "$HAS_DISPLAY" = "false" ]; then
    logg info "Fallback: Running in headless mode"
    chezmoi apply $COMMON_MODIFIERS $DEBUG_MODIFIER $KEEP_GOING_MODIFIER $FORCE_MODIFIER || CHEZMOI_EXIT_CODE=$?
  else
    logg info "Running: ${CHEZMOI_CMD[*]}"
    "${CHEZMOI_CMD[@]}" 2>&1 | tee /dev/tty | ts '[%Y-%m-%d %H:%M:%S]' > "$LOG_FILE" || CHEZMOI_EXIT_CODE=$?
    # Strip ANSI escape codes from log if unbuffer was used
    if command -v unbuffer > /dev/null; then
      UNBUFFER_TMP="$(mktemp)"
      unbuffer cat "$LOG_FILE" > "$UNBUFFER_TMP"
      mv -f "$UNBUFFER_TMP" "$LOG_FILE"
    fi
  fi

  ### Handle exit codes in log
  if [ -f "$LOG_FILE" ] && grep -q 'chezmoi: exit status 140' "$LOG_FILE"; then
    beforeRebootDarwin
    logg info "Chezmoi signalled that a reboot is necessary to apply a system update"
    logg info "Running softwareupdate with the reboot flag"
    sudo softwareupdate -i -a -R --agree-to-license && exit
  fi

  ### Handle actual process exit code
  if [ -n "$CHEZMOI_EXIT_CODE" ]; then
    logg error "Chezmoi encountered an error and exited with an exit code of $CHEZMOI_EXIT_CODE"
  else
    logg info 'Finished provisioning the system'
  fi
}

# @description Ensure temporary passwordless sudo privileges are removed from `/etc/sudoers`
removePasswordlessSudo() {
  if [ -d /Applications ] && [ -d /System ]; then
    logg info "Ensuring $USER is still an admin"
    sudo dscl . -merge /Groups/admin GroupMembership "$USER"
  fi
  if command -v gsed > /dev/null; then
    sudo gsed -i '/# TEMPORARY FOR INSTALL DOCTOR/d' /etc/sudoers || logg warn 'Failed to remove passwordless sudo from the /etc/sudoers file'
  elif [[ "$OSTYPE" == 'darwin'* ]]; then
    sudo sed -i '' '/# TEMPORARY FOR INSTALL DOCTOR/d' /etc/sudoers || logg warn 'Failed to remove passwordless sudo from the /etc/sudoers file'
  else
    sudo sed -i '/# TEMPORARY FOR INSTALL DOCTOR/d' /etc/sudoers || logg warn 'Failed to remove passwordless sudo from the /etc/sudoers file'
  fi
}

# @description Render the `docs/terminal/post-install.md` file to the terminal at the end of the provisioning process
postProvision() {
  logg info 'Provisioning complete!'
  if command -v glow > /dev/null && [ -f "${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/docs/terminal/post-install.md" ]; then
    glow "${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/docs/terminal/post-install.md"
  fi
}

# @description Installs VIM plugins (outside of Chezmoi because of terminal GUI issues)
vimPlugins() {
  if command -v vim > /dev/null; then
    logg info 'Running vim +CocUpdateSync +qall' && vim +CocUpdateSync +qall >/dev/null 2>&1 &
    disown
    logg info "Installing VIM plugins with vim +'PlugInstall --sync' +qall" && vim +'PlugInstall --sync' +qall
  else
    logg info 'VIM not in PATH'
  fi
}

# @description Creates apple user if user is running this script as root and continues the script execution with the new `apple` user.
#     Requires `SUDO_PASSWORD` to be set when running as root (will not default to an insecure password).
function ensureAppleUser() {
  # Check if the script is running as root
  if [ "$(id -u)" -eq 0 ]; then
    logg info "You are running as root. Proceeding with user creation."

    # Require SUDO_PASSWORD to be explicitly set when running as root
    if [ -z "$SUDO_PASSWORD" ]; then
      logg error "SUDO_PASSWORD must be set when running as root. Cannot create user with an insecure default password."
      logg info "Usage: SUDO_PASSWORD=yourpassword bash <(curl -sSL https://install.doctor/start)"
      exit 1
    fi

    # Check if 'apple' user exists
    if id "apple" &>/dev/null; then
      logg info "User 'apple' already exists. Skipping creation."
    else
      # Create a new user 'apple'
      logg info "Creating user 'apple'..."
      if command -v useradd &>/dev/null; then
        # For Linux distributions
        useradd -m -s /bin/bash apple
      elif command -v dscl &>/dev/null; then
        # For macOS
        dscl . -create /Users/apple
        dscl . -create /Users/apple UserShell /bin/bash
        NEW_UID="$(dscl . -list /Users UniqueID | awk '{print $2}' | sort -n | tail -1)"
        dscl . -create /Users/apple UniqueID "$((NEW_UID + 1))"
        dscl . -create /Users/apple PrimaryGroupID 20
        dscl . -create /Users/apple NFSHomeDirectory /Users/apple
        mkdir -p /Users/apple
        chown -R apple:staff /Users/apple
      else
        logg info "Unsupported system. Exiting."
        exit 1
      fi

      # Set the password for 'apple'
      logg info "Setting a password for 'apple'..."
      echo "apple:$SUDO_PASSWORD" | chpasswd 2>/dev/null || \
      (echo "$SUDO_PASSWORD" | passwd --stdin apple 2>/dev/null || \
      (echo "$SUDO_PASSWORD" | dscl . -passwd /Users/apple "$SUDO_PASSWORD" 2>/dev/null))

      # Grant sudo privileges to 'apple'
      logg info "Granting sudo privileges to 'apple'..."
      if command -v usermod &>/dev/null; then
        usermod -aG sudo apple
      elif command -v dseditgroup &>/dev/null; then
        dseditgroup -o edit -a apple -t user admin
      else
        logg info "Unable to grant sudo privileges. Continuing anyway."
      fi
    fi

    # Switch to 'apple' user to continue the script — use mktemp with restrictive permissions
    ENV_VARS_FILE="$(mktemp /tmp/env_vars.XXXXXX)"
    chmod 600 "$ENV_VARS_FILE"
    export -p > "$ENV_VARS_FILE"
    chown apple "$ENV_VARS_FILE"
    logg info "Running install.doctor/start with the apple user"
    su - apple -c "source '$ENV_VARS_FILE' && rm -f '$ENV_VARS_FILE' && export HOME='/home/apple' && export USER='apple' && cd /home/apple && bash <(curl -sSL https://install.doctor/start)"
    exit 0
  else
    logg info "You are not running as root. Proceeding with the current user."
  fi
}

# @description Main orchestration function that defines the execution order of all provisioning steps.
#     This function is the primary entry point and runs the following steps in order:
#
#     1. **User Setup** - Creates a non-root user if running as root (required for Homebrew)
#     2. **Environment Setup** - Loads Homebrew, sets environment variables, configures CI defaults
#     3. **Network Preparation** - Disconnects WARP VPN to prevent conflicts during provisioning
#     4. **Sudo Setup** - Temporarily grants passwordless sudo (with timeout, auto-skips on failure)
#     5. **Dependencies** - Installs basic system dependencies (curl, git, etc.)
#     6. **Repository** - Clones or updates the Install Doctor source repository
#     7. **macOS Setup** - Ensures full disk access and imports CloudFlare certificates (macOS only)
#     8. **Homebrew** - Ensures Homebrew is installed and installs required brew packages
#     9. **Qubes** - Handles Qubes dom0 provisioning if applicable
#     10. **Chezmoi Init** - Initializes Chezmoi configuration and prompts for settings
#     11. **Chezmoi Apply** - Runs the main provisioning via `chezmoi apply`
#     12. **Cleanup** - Removes temporary passwordless sudo, installs VIM plugins
#     13. **Reboot Check** - Reboots the system if required by updates
#     14. **Post-Install** - Displays post-installation instructions
provisionLogic() {
  logg info "Ensuring script is not run with root" && ensureAppleUser
  logg info "Attempting to load Homebrew" && loadHomebrew
  logg info "Setting environment variables" && setEnvironmentVariables
  logg info "Handling CI variables" && setCIEnvironmentVariables
  logg info "Ensuring WARP is disconnected" && ensureWarpDisconnected
  logg info "Applying passwordless sudo" && setupPasswordlessSudo
  logg info "Ensuring system dependencies are installed" && ensureBasicDeps
  logg info "Cloning / updating source repository" && cloneChezmoiSourceRepo
  if [ -d /Applications ] && [ -d /System ]; then
    ### macOS only
    logg info "Ensuring full disk access from current terminal application" && ensureFullDiskAccess
    logg info "Ensuring CloudFlare certificate imported into system certificates" && importCloudFlareCert
  fi
  logg info "Ensuring Homebrew is available" && ensureHomebrew
  logg info "Installing Homebrew packages" && ensureHomebrewDeps
  logg info "Handling Qubes dom0 logic (if applicable)" && handleQubesDom0
  logg info "Handling pre-provision logic" && initChezmoiAndPrompt
  logg info "Running the Chezmoi provisioning" && runChezmoi
  logg info "Ensuring temporary passwordless sudo is removed" && removePasswordlessSudo
  logg info "Running post-install VIM plugin installations" && vimPlugins
  logg info "Determining whether or not to reboot" && handleRequiredReboot
  logg info "Handling post-provision logic" && postProvision
}
provisionLogic
