#!/usr/bin/env bash

# @file .config/scripts/start.sh
# @brief Ensures Task is installed and up-to-date and then runs `task start`
# @description
#   This script will ensure [Task](https://github.com/go-task/task) is up-to-date
#   and then run the `start` task which is generally a good entrypoint for any repository
#   that is using the Megabyte Labs templating/taskfile system. The `start` task will
#   ensure that the latest upstream changes are retrieved, that the project is
#   properly generated with them, and that all the development dependencies are installed.
#   Documentation on Taskfile.yml syntax can be found [here](https://taskfile.dev/).
git config url."https://gitlab.com/".insteadOf git@gitlab.com:
          git config url."https://github.com/".insteadOf git@github.com:
set -eo pipefail

# @description Initialize variables
DELAYED_CI_SYNC=""
ENSURED_TASKFILES=""
export HOMEBREW_NO_INSTALL_CLEANUP=true
export HOMEBREW_NO_ANALYTICS=1

# @description Ensure permissions in CI environments
if [ -n "$CI" ]; then
  if type sudo &> /dev/null; then
    sudo chown -R "$(whoami):$(whoami)" .
  fi
fi

# @description Ensure .config/log is present
if [ ! -f .config/log ]; then
  mkdir -p .config
  if type curl &> /dev/null; then
    curl -sSL https://gitlab.com/megabyte-labs/common/shared/-/raw/master/common/.config/log > .config/log
  fi
fi

# @description Ensure .config/log is executable
chmod +x .config/log

# @description Acquire unique ID for this script
if [ -z "$CI" ]; then
  if type md5sum &> /dev/null; then
    FILE_HASH="$(md5sum "$0" | sed 's/\s.*$//')"
  else
    FILE_HASH="$(date -r "$0" +%s)"
  fi
else
  FILE_HASH="none"
fi

# @description Caches values from commands
function cache() {
  local DIR="${CACHE_DIR:-.cache}"
  if ! test -d "$DIR"; then
    mkdir -p "$DIR"
  fi
  local FN="$DIR/${LINENO}-${FILE_HASH}"
  if ! test -f "$FN" ; then
    "$@" > "$FN"
  fi
  cat "$FN"
}

# @description Formats log statements
function format() {
  # shellcheck disable=SC2001,SC2016
  ANSI_STR="$(echo "$1" | sed 's/^\([^`]*\)`\([^`]*\)`/\1\\e[100;1m \2 \\e[0;39m/')"
  if [[ $ANSI_STR == *'`'*'`'* ]]; then
    ANSI_STR="$(format "$ANSI_STR")"
  fi
  echo -e "$ANSI_STR"
}

# @description Proxy function for handling logs in this script
function logger() {
  if [ -f .config/log ]; then
    .config/log "$1" "$2"
  else
    if [ "$1" == 'error' ]; then
      echo -e "\e[1;41m  ERROR   \e[0m $(format "$2")\e[0;39m"
    elif [ "$1" == 'info' ]; then
      echo -e "\e[1;46m   INFO   \e[0m $(format "$2")\e[0;39m"
    elif [ "$1" == 'success' ]; then
      echo -e "\e[1;42m SUCCESS  \e[0m $(format "$2")\e[0;39m"
    elif [ "$1" == 'warn' ]; then
      echo -e "\e[1;43m WARNING  \e[0m $(format "$2")\e[0;39m"
    else
      echo "$2"
    fi
  fi
}

# @description Helper function for ensurePackageInstalled for Alpine installations
function ensureAlpinePackageInstalled() {
  if type sudo &> /dev/null && [ "$CAN_USE_SUDO" != 'false' ]; then
    sudo apk --no-cache add "$1"
  else
    apk --no-cache add "$1"
  fi
}

# @description Helper function for ensurePackageInstalled for ArchLinux installations
function ensureArchPackageInstalled() {
  if type sudo &> /dev/null && [ "$CAN_USE_SUDO" != 'false' ]; then
    sudo pacman update
    sudo pacman -S "$1"
  else
    pacman update
    pacman -S "$1"
  fi
}

# @description Helper function for ensurePackageInstalled for Debian installations
function ensureDebianPackageInstalled() {
  if type sudo &> /dev/null && [ "$CAN_USE_SUDO" != 'false' ]; then
    sudo apt-get update
    sudo apt-get install -y "$1"
  else
    apt-get update
    apt-get install -y "$1"
  fi
}

# @description Helper function for ensurePackageInstalled for RedHat installations
function ensureRedHatPackageInstalled() {
  if type sudo &> /dev/null && [ "$CAN_USE_SUDO" != 'false' ]; then
    if type dnf &> /dev/null; then
      sudo dnf install -y "$1"
    else
      sudo yum install -y "$1"
    fi
  else
    if type dnf &> /dev/null; then
      dnf install -y "$1"
    else
      yum install -y "$1"
    fi
  fi
}

# @description Installs package when user is root on Linux
#
# @arg $1 string The name of the package that must be present
#
# @exitcode 0 The package was successfully installed
# @exitcode 1+ If there was an error, the package needs to be installed manually, or if the OS is unsupported
function ensureRootPackageInstalled() {
  export CAN_USE_SUDO='false'
  if ! type "$1" &> /dev/null; then
    if [[ "$OSTYPE" == 'linux'* ]]; then
      if [ -f "/etc/redhat-release" ]; then
        ensureRedHatPackageInstalled "$1"
      elif [ -f "/etc/debian_version" ]; then
        ensureDebianPackageInstalled "$1"
      elif [ -f "/etc/arch-release" ]; then
        ensureArchPackageInstalled "$1"
      elif [ -f "/etc/alpine-release" ]; then
        ensureAlpinePackageInstalled "$1"
      fi
    fi
  fi
}

# @description If the user is running this script as root, then create a new user named
# megabyte and restart the script with that user. This is required because Homebrew
# can only be invoked by non-root users.
if [ -z "$NO_INSTALL_HOMEBREW" ] && [ "$USER" == "root" ] && [ -z "$INIT_CWD" ] && type useradd &> /dev/null; then
  # shellcheck disable=SC2016
  logger info 'Running as root - creating seperate user named megabyte to run script with'
  echo "megabyte ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
  useradd -m -s "$(which bash)" --gecos "" --disabled-login -c "Megabyte Labs" megabyte > /dev/null || ROOT_EXIT_CODE=$?
  if [ -n "$ROOT_EXIT_CODE" ]; then
    # shellcheck disable=SC2016
    logger info 'User megabyte already exists'
  fi
  ensureRootPackageInstalled "sudo"
  # shellcheck disable=SC2016
  logger info 'Reloading the script with the megabyte user'
  exec su megabyte "$0" -- "$@"
fi

# @description Ensures ~/.local/bin is in the PATH variable on *nix machines and
# exits with an error on unsupported OS types
#
# @set PATH string The updated PATH with a reference to ~/.local/bin
#
# @noarg
#
# @exitcode 0 If the PATH was appropriately updated or did not need updating
# @exitcode 1+ If the OS is unsupported
function ensureLocalPath() {
  if [[ "$OSTYPE" == 'darwin'* ]] || [[ "$OSTYPE" == 'linux'* ]]; then
    # shellcheck disable=SC2016
    PATH_STRING='export PATH="$HOME/.local/bin:$PATH"'
    mkdir -p "$HOME/.local/bin"
    if ! grep "$PATH_STRING" < "$HOME/.profile" > /dev/null; then
      echo -e "${PATH_STRING}\n" >> "$HOME/.profile"
      logger info "Updated the PATH variable to include ~/.local/bin in $HOME/.profile"
    fi
  elif [[ "$OSTYPE" == 'cygwin' ]] || [[ "$OSTYPE" == 'msys' ]] || [[ "$OSTYPE" == 'win32' ]]; then
    logger error "Windows is not directly supported. Use WSL or Docker." && exit 1
  elif [[ "$OSTYPE" == 'freebsd'* ]]; then
    logger error "FreeBSD support not added yet" && exit 1
  else
    logger warn "System type not recognized"
  fi
}

# @description Ensures given package is installed on a system.
#
# @arg $1 string The name of the package that must be present
#
# @exitcode 0 The package(s) were successfully installed
# @exitcode 1+ If there was an error, the package needs to be installed manually, or if the OS is unsupported
function ensurePackageInstalled() {
  export CAN_USE_SUDO='true'
  if ! type "$1" &> /dev/null; then
    if [[ "$OSTYPE" == 'darwin'* ]]; then
      brew install "$1"
    elif [[ "$OSTYPE" == 'linux'* ]]; then
      if [ -f "/etc/redhat-release" ]; then
        ensureRedHatPackageInstalled "$1"
      elif [ -f "/etc/debian_version" ]; then
        ensureDebianPackageInstalled "$1"
      elif [ -f "/etc/arch-release" ]; then
        ensureArchPackageInstalled "$1"
      elif [ -f "/etc/alpine-release" ]; then
        ensureAlpinePackageInstalled "$1"
      elif type dnf &> /dev/null || type yum &> /dev/null; then
        ensureRedHatPackageInstalled "$1"
      elif type apt-get &> /dev/null; then
        ensureDebianPackageInstalled "$1"
      elif type pacman &> /dev/null; then
        ensureArchPackageInstalled "$1"
      elif type apk &> /dev/null; then
        ensureAlpinePackageInstalled "$1"
      else
        logger error "$1 is missing. Please install $1 to continue." && exit 1
      fi
    elif [[ "$OSTYPE" == 'cygwin' ]] || [[ "$OSTYPE" == 'msys' ]] || [[ "$OSTYPE" == 'win32' ]]; then
      logger error "Windows is not directly supported. Use WSL or Docker." && exit 1
    elif [[ "$OSTYPE" == 'freebsd'* ]]; then
      logger error "FreeBSD support not added yet" && exit 1
    else
      logger error "System type not recognized"
    fi
  fi
}

# @description Ensures the latest version of Task is installed to `/usr/local/bin` (or `~/.local/bin`, as
# a fallback.
#
# @noarg
#
# @exitcode 0 If the package is already present and up-to-date or if it was installed/updated
# @exitcode 1+ If the OS is unsupported or if there was an error either installing the package or setting the PATH
function ensureTaskInstalled() {
  # @description Release API URL used to get the latest release's version
  TASK_RELEASE_API="https://api.github.com/repos/go-task/task/releases/latest"
  if ! type task &> /dev/null; then
    if [[ "$OSTYPE" == 'darwin'* ]] || [[ "$OSTYPE" == 'linux-gnu'* ]] || [[ "$OSTYPE" == 'linux-musl' ]]; then
      installTask
    elif [[ "$OSTYPE" == 'cygwin' ]] || [[ "$OSTYPE" == 'msys' ]] || [[ "$OSTYPE" == 'win32' ]]; then
      logger error "Windows is not directly supported. Use WSL or Docker." && exit 1
    elif [[ "$OSTYPE" == 'freebsd'* ]]; then
      logger error "FreeBSD support not added yet" && exit 1
    else
      logger error "System type not recognized. You must install task manually." && exit 1
    fi
  else
    mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/megabyte/start.sh"
    if [ -f "${XDG_CACHE_HOME:-$HOME/.cache}/megabyte/start.sh/bodega-update-check" ]; then
      TASK_UPDATE_TIME="$(cat "${XDG_CACHE_HOME:-$HOME/.cache}/megabyte/start.sh/bodega-update-check")"
    else
      TASK_UPDATE_TIME="$(date +%s)"
      echo "$TASK_UPDATE_TIME" > "${XDG_CACHE_HOME:-$HOME/.cache}/megabyte/start.sh/bodega-update-check"
    fi
    # shellcheck disable=SC2004
    TIME_DIFF="$(($(date +%s) - $TASK_UPDATE_TIME))"
    # Only run if it has been at least 15 minutes since last attempt
    if [ "$TIME_DIFF" -gt 900 ] || [ "$TIME_DIFF" -lt 5 ]; then
      date +%s > "${XDG_CACHE_HOME:-$HOME/.cache}/megabyte/start.sh/bodega-update-check"
      logger info "Checking for latest version of Task"
      CURRENT_VERSION="$(task --version | cut -d' ' -f3 | cut -c 2-)"
      LATEST_VERSION="$(curl -s "$TASK_RELEASE_API" | grep tag_name | cut -c 17- | sed 's/\",//')"
      if printf '%s\n%s\n' "$LATEST_VERSION" "$CURRENT_VERSION" | sort -V -c &> /dev/null; then
        logger info "Task is already up-to-date"
      else
        logger info "A new version of Task is available (version $LATEST_VERSION)"
        logger info "The current version of Task installed is $CURRENT_VERSION"
        if ! type task &> /dev/null; then
          logger info "Task is not available in the PATH"
          installTask
        else
          if rm -f "$(which task)"; then
            logger info "Removing task was successfully done without sudo"
            installTask
          elif sudo rm -f "$(which task)"; then
            logger info "Removing task was successfully done with sudo"
            installTask
          else
            logger warn "Unable to remove previous version of Task"
          fi
        fi
      fi
    fi
  fi
}

# @description Helper function for ensureTaskInstalled that performs the installation of Task.
#
# @see ensureTaskInstalled
#
# @noarg
#
# @exitcode 0 If Task installs/updates properly
# @exitcode 1+ If the installation fails
function installTask() {
  # @description Release URL to use when downloading [Task](https://github.com/go-task/task)
  TASK_RELEASE_URL="https://github.com/go-task/task/releases/latest"
  CHECKSUM_DESTINATION=/tmp/megabytelabs/task_checksums.txt
  CHECKSUMS_URL="$TASK_RELEASE_URL/download/task_checksums.txt"
  DOWNLOAD_DESTINATION=/tmp/megabytelabs/task.tar.gz
  TMP_DIR=/tmp/megabytelabs
  logger info "Checking if install target is macOS or Linux"
  if [[ "$OSTYPE" == 'darwin'* ]]; then
    DOWNLOAD_URL="$TASK_RELEASE_URL/download/task_darwin_amd64.tar.gz"
  else
    DOWNLOAD_URL="$TASK_RELEASE_URL/download/task_linux_amd64.tar.gz"
  fi
  logger "Creating folder for Task download"
  mkdir -p "$(dirname "$DOWNLOAD_DESTINATION")"
  logger info "Downloading latest version of Task"
  curl -sSL "$DOWNLOAD_URL" -o "$DOWNLOAD_DESTINATION"
  curl -sSL "$CHECKSUMS_URL" -o "$CHECKSUM_DESTINATION"
  DOWNLOAD_BASENAME="$(basename "$DOWNLOAD_URL")"
  DOWNLOAD_SHA256="$(grep "$DOWNLOAD_BASENAME" < "$CHECKSUM_DESTINATION" | cut -d ' ' -f 1)"
  sha256 "$DOWNLOAD_DESTINATION" "$DOWNLOAD_SHA256" > /dev/null
  logger success "Validated checksum"
  mkdir -p "$TMP_DIR/task"
  tar -xzf "$DOWNLOAD_DESTINATION" -C "$TMP_DIR/task" > /dev/null
  if type task &> /dev/null && [ -w "$(which task)" ]; then
    TARGET_BIN_DIR="."
    TARGET_DEST="$(which task)"
  else
    if [ "$USER" == "root" ] || (type sudo &> /dev/null && sudo -n true); then
      TARGET_BIN_DIR='/usr/local/bin'
    else
      TARGET_BIN_DIR="$HOME/.local/bin"
    fi
    TARGET_DEST="$TARGET_BIN_DIR/task"
  fi
  if [ "$USER" == "root" ]; then
    mkdir -p "$TARGET_BIN_DIR"
    mv "$TMP_DIR/task/task" "$TARGET_DEST"
  elif type sudo &> /dev/null && sudo -n true; then
    sudo mkdir -p "$TARGET_BIN_DIR"
    sudo mv "$TMP_DIR/task/task" "$TARGET_DEST"
  else
    mkdir -p "$TARGET_BIN_DIR"
    mv "$TMP_DIR/task/task" "$TARGET_DEST"
  fi
  logger success "Installed Task to $TARGET_DEST"
  rm "$CHECKSUM_DESTINATION"
  rm "$DOWNLOAD_DESTINATION"
}

# @description Verifies the SHA256 checksum of a file
#
# @arg $1 string Path to the file
# @arg $2 string The SHA256 signature
#
# @exitcode 0 The checksum is valid or the system is unrecognized
# @exitcode 1+ The OS is unsupported or if the checksum is invalid
function sha256() {
  if [[ "$OSTYPE" == 'darwin'* ]]; then
    if type brew &> /dev/null && ! type sha256sum &> /dev/null; then
      brew install coreutils
    else
      logger warn "Brew is not installed - this may cause issues"
    fi
    if type brew &> /dev/null; then
      PATH="$(brew --prefix)/opt/coreutils/libexec/gnubin:$PATH"
    fi
    if type sha256sum &> /dev/null; then
      echo "$2 $1" | sha256sum -c
    else
      logger warn "Checksum validation is being skipped for $1 because the sha256sum program is not available"
    fi
  elif [[ "$OSTYPE" == 'linux-gnu'* ]]; then
    if ! type shasum &> /dev/null; then
      logger warn "Checksum validation is being skipped for $1 because the shasum program is not installed"
    else
      echo "$2  $1" | shasum -s -a 256 -c
    fi
  elif [[ "$OSTYPE" == 'linux-musl' ]]; then
    if ! type sha256sum &> /dev/null; then
      logger warn "Checksum validation is being skipped for $1 because the sha256sum program is not available"
    else
      echo "$2  $1" | sha256sum -c
    fi
  elif [[ "$OSTYPE" == 'cygwin' ]] || [[ "$OSTYPE" == 'msys' ]] || [[ "$OSTYPE" == 'win32' ]]; then
    logger error "Windows is not directly supported. Use WSL or Docker." && exit 1
  elif [[ "$OSTYPE" == 'freebsd'* ]]; then
    logger error "FreeBSD support not added yet" && exit 1
  else
    logger warn "System type not recognized. Skipping checksum validation."
  fi
}

# @description Ensures the Taskfile.yml is accessible
function ensureTaskfiles() {
  if [ -z "$ENSURED_TASKFILES" ]; then
    # shellcheck disable=SC2030
    task donothing || BOOTSTRAP_EXIT_CODE=$?
    mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/megabyte/start.sh"
    if [ -f "${XDG_CACHE_HOME:-$HOME/.cache}/megabyte/start.sh/ensure-taskfiles" ]; then
      TASK_UPDATE_TIME="$(cat "${XDG_CACHE_HOME:-$HOME/.cache}/megabyte/start.sh/ensure-taskfiles")"
    else
      TASK_UPDATE_TIME="$(date +%s)"
      echo "$TASK_UPDATE_TIME" > "${XDG_CACHE_HOME:-$HOME/.cache}/megabyte/start.sh/ensure-taskfiles"
    fi
    # shellcheck disable=SC2004
    TIME_DIFF="$(($(date +%s) - $TASK_UPDATE_TIME))"
    # Only run if it has been at least 60 minutes since last attempt
    if [ -n "$BOOTSTRAP_EXIT_CODE" ] || [ "$TIME_DIFF" -gt 3600 ] || [ "$TIME_DIFF" -lt 5 ] || [ -n "$FORCE_TASKFILE_UPDATE" ]; then
      logger info 'Grabbing latest Taskfiles by downloading shared-master.tar.gz'
      # shellcheck disable=SC2031
      date +%s > "${XDG_CACHE_HOME:-$HOME/.cache}/megabyte/start.sh/ensure-taskfiles"
      ENSURED_TASKFILES="true"
      if [ -d common/.config/taskfiles ]; then
        if [[ "$OSTYPE" == 'darwin'* ]]; then
          cp -rf common/.config/taskfiles/ .config/taskfiles
        else
          cp -rT common/.config/taskfiles/ .config/taskfiles
        fi
      else
        mkdir -p .config/taskfiles
        curl -sSL https://gitlab.com/megabyte-labs/common/shared/-/archive/master/shared-master.tar.gz > shared-master.tar.gz
        tar -xzf shared-master.tar.gz > /dev/null
        rm shared-master.tar.gz
        rm -rf .config/taskfiles
        mv shared-master/common/.config/taskfiles .config/taskfiles
        mv shared-master/common/.editorconfig .editorconfig
        mv shared-master/common/.gitignore .gitignore
        rm -rf shared-master
      fi
    fi
    if [ -n "$BOOTSTRAP_EXIT_CODE" ] && ! task donothing; then
      # task donothing still does not work so issue must be with main Taskfile.yml
      # shellcheck disable=SC2016
      logger warn 'Something is wrong with the Taskfile.yml - grabbing main Taskfile.yml'
      git checkout HEAD~1 -- Taskfile.yml
      if ! task donothing; then
        logger error 'Error appears to be with main Taskfile.yml'
      else
        logger warn 'Error appears to be with one of the included Taskfiles'
        logger info 'Removing and cloning Taskfile library from upstream repository'
        rm -rf .config/taskfiles
        FORCE_TASKFILE_UPDATE=true ensureTaskfiles
        if task donothing; then
          logger warn 'The issue was remedied by cloning the latest Taskfile includes'
        fi
      fi
    fi
  fi
}

# @description Ensures basic files like package.json and Taskfile.yml are present
function ensureProjectBootstrapped() {
  if [ ! -f start.sh ] || [ ! -f package.json ] || [ ! -f Taskfile.yml ]; then
    if [ ! -f start.sh ]; then
      curl -sSL https://gitlab.com/megabyte-labs/common/shared/-/raw/master/common/start.sh > start.sh
    fi
    if [ ! -f package.json ]; then
      curl -sSL https://gitlab.com/megabyte-labs/common/shared/-/raw/master/package.json > package.json
    fi
    if [ ! -f Taskfile.yml ]; then
      curl -sSL https://gitlab.com/megabyte-labs/common/shared/-/raw/master/Taskfile.yml > Taskfile.yml
    fi
    ensureTaskfiles
    task new:project
  fi
}

##### Main Logic #####

if [ ! -f "$HOME/.profile" ]; then
  touch "$HOME/.profile"
fi

# @description Ensure git hosts are all in ~/.ssh/known_hosts
mkdir -p ~/.ssh
chmod 700 ~/.ssh
if [ ! -f ~/.ssh/known_hosts ]; then
  touch ~/.ssh/known_hosts
  chmod 600 ~/.ssh/known_hosts
fi
if ! grep -q "^gitlab.com " ~/.ssh/known_hosts; then
  ssh-keyscan gitlab.com >> ~/.ssh/known_hosts 2>/dev/null
fi
if ! grep -q "^github.com " ~/.ssh/known_hosts; then
  ssh-keyscan github.com >> ~/.ssh/known_hosts 2>/dev/null
fi
if ! grep -q "^bitbucket.org " ~/.ssh/known_hosts; then
  ssh-keyscan bitbucket.org >> ~/.ssh/known_hosts 2>/dev/null
fi

# @description Ensures ~/.local/bin is in PATH
ensureLocalPath

# @description Ensures base dependencies are installed
if [[ "$OSTYPE" == 'darwin'* ]]; then
  if ! type curl &> /dev/null && type brew &> /dev/null; then
    brew install curl
  fi
  if ! type git &> /dev/null; then
    # shellcheck disable=SC2016
    logger info 'Git is not present. A password may be required to run sudo xcode-select --install'
    sudo xcode-select --install
  fi
elif [[ "$OSTYPE" == 'linux-gnu'* ]] || [[ "$OSTYPE" == 'linux-musl'* ]]; then
  if ! type curl &> /dev/null || ! type git &> /dev/null || ! type gzip &> /dev/null || ! type sudo &> /dev/null || ! type jq &> /dev/null; then
    ensurePackageInstalled "curl"
    ensurePackageInstalled "file"
    ensurePackageInstalled "git"
    ensurePackageInstalled "gzip"
    ensurePackageInstalled "sudo"
    ensurePackageInstalled "jq"
  fi
fi

# @description Ensures Homebrew, Poetry, and Volta are installed
if [ -z "$NO_INSTALL_HOMEBREW" ]; then
  if [[ "$OSTYPE" == 'darwin'* ]] || [[ "$OSTYPE" == 'linux-gnu'* ]] || [[ "$OSTYPE" == 'linux-musl'* ]]; then
    if [ -z "$INIT_CWD" ]; then
      if ! type brew &> /dev/null; then
        if type sudo &> /dev/null && sudo -n true; then
          echo | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        else
          logger warn "Homebrew is not installed. The script will attempt to install Homebrew and you might be prompted for your password."
          /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || BREW_EXIT_CODE="$?"
          if [ -n "$BREW_EXIT_CODE" ]; then
            if command -v brew > /dev/null; then
              .config/log warn "Homebrew was installed but part of the installation failed. Retrying again after changing a few things.."
              BREW_DIRS="share/man share/doc share/zsh/site-functions etc/bash_completion.d"
              for BREW_DIR in $BREW_DIRS; do
                if [ -d "$(brew --prefix)/$BREW_DIR" ]; then
                  sudo chown -R "$(whoami)" "$(brew --prefix)/$BREW_DIR"
                fi
              done
              brew update --force --quiet
            fi
          fi
        fi
      fi
      if ! (grep "/bin/brew shellenv" < "$HOME/.profile" &> /dev/null) && [[ "$OSTYPE" != 'darwin'* ]]; then
        # shellcheck disable=SC2016
        logger info 'Adding linuxbrew source command to ~/.profile'
        # shellcheck disable=SC2016
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$HOME/.profile"
      fi
      if [ -f "$HOME/.profile" ]; then
        # shellcheck disable=SC1091
        . "$HOME/.profile" &> /dev/null || true
      fi
      if ! type poetry &> /dev/null; then
        # shellcheck disable=SC2016
        brew install poetry || logger info 'There may have been an issue installing poetry with brew'
      fi
      if ! type jq &> /dev/null; then
        # shellcheck disable=SC2016
        brew install jq || logger info 'There may have been an issue installiny jq with brew'
      fi
      if ! type yq &> /dev/null; then
        # shellcheck disable=SC2016
        brew install yq || logger info 'There may have been an issue installing yq with brew'
      fi
      if ! type volta &> /dev/null || ! type node &> /dev/null; then
        # shellcheck disable=SC2016
        curl https://get.volta.sh | bash
        # shellcheck disable=SC1091
        . "$HOME/.profile" &> /dev/null || true
        volta setup
        volta install node
      fi
    fi
  fi
fi

# @description Second attempt to install yq if snap is on system but the Homebrew install was skipped
if ! type yq &> /dev/null && type snap &> /dev/null; then
  if type sudo &> /dev/null; then
    sudo snap install yq
  else
    snap install yq
  fi
fi

# @description Attempts to pull the latest changes if the folder is a git repository.
if [ -d .git ] && type git &> /dev/null; then
  if [ -n "$GROUP_ACCESS_TOKEN" ] && [ -n "$GITLAB_CI_EMAIL" ] && [ -n "$GITLAB_CI_NAME" ] && [ -n "$GITLAB_CI" ]; then
    git remote set-url origin "https://root:$GROUP_ACCESS_TOKEN@$CI_SERVER_HOST/$CI_PROJECT_PATH.git"
    git config user.email "$GITLAB_CI_EMAIL"
    git config user.name "$GITLAB_CI_NAME"
  fi
  mkdir -p .cache/start.sh
  if [ -f .cache/start.sh/git-pull-time ]; then
    GIT_PULL_TIME="$(cat .cache/start.sh/git-pull-time)"
  else
    GIT_PULL_TIME=$(date +%s)
    echo "$GIT_PULL_TIME" > .cache/start.sh/git-pull-time
  fi
  # shellcheck disable=SC2004
  TIME_DIFF="$(($(date +%s) - $GIT_PULL_TIME))"
  # Only run if it has been at least 15 minutes since last attempt
  if [ "$TIME_DIFF" -gt 900 ] || [ "$TIME_DIFF" -lt 5 ]; then
    date +%s > .cache/start.sh/git-pull-time
    git fetch origin
    GIT_POS="$(git rev-parse --abbrev-ref HEAD)"
    logger info 'Current branch is '"$GIT_POS"''
    if [ "$GIT_POS" == 'synchronize' ] || [ "$CI_COMMIT_REF_NAME" == 'synchronize' ]; then
      git reset --hard origin/master
      git push --force origin synchronize || FORCE_SYNC_ERR=$?
      if [ -n "$FORCE_SYNC_ERR" ] && type task &> /dev/null; then
        NO_GITLAB_SYNCHRONIZE=true task ci:synchronize || CI_SYNC_TASK_ISSUE=$?
        if [ -n "$CI_SYNC_TASK_ISSUE" ]; then
          ensureTaskfiles
          NO_GITLAB_SYNCHRONIZE=true task ci:synchronize
        fi
      else
        DELAYED_CI_SYNC=true
      fi
    elif [ "$GIT_POS" == 'HEAD' ]; then
      if [ -n "$GITLAB_CI" ]; then
        printenv
      fi
    fi
    git pull --force origin master --ff-only || GIT_PULL_FAIL="$?"
    if [ -n "$GIT_PULL_FAIL" ]; then
      git config url."https://gitlab.com/".insteadOf git@gitlab.com:
      git config url."https://github.com/".insteadOf git@github.com:
      git pull --force origin master --ff-only || true
    fi
    ROOT_DIR="$PWD"
    if ls .modules/*/ > /dev/null 2>&1; then
      for SUBMODULE_PATH in .modules/*/; do
        cd "$SUBMODULE_PATH"
        DEFAULT_BRANCH=$(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5)
        git reset --hard HEAD
        git checkout "$DEFAULT_BRANCH"
        git pull origin "$DEFAULT_BRANCH" --ff-only || true
        cd "$ROOT_DIR"
      done
      # shellcheck disable=SC2016
      logger success 'Ensured submodules in the .modules folder are pointing to the master branch'
    fi
  fi
fi

# @description Ensures Task is installed and properly configured
ensureTaskInstalled

# @description Ensures Taskfiles are up-to-date
logger info 'Ensuring Taskfile.yml files are all in good standing'
ensureTaskfiles

# @description Try synchronizing again (in case Task was not available yet)
if [ "$DELAYED_CI_SYNC" == 'true' ]; then
  logger info 'Attempting to synchronize CI..'
  task ci:synchronize
fi

# @description Run the start logic, if appropriate
if [ -z "$CI" ] && [ -z "$START" ] && [ -z "$INIT_CWD" ]; then
  if ! type pipx &> /dev/null; then
    task install:software:pipx
  fi
  logger info "Sourcing profile located in $HOME/.profile"
  # shellcheck disable=SC1091
  . "$HOME/.profile" &> /dev/null || true
  ensureProjectBootstrapped
  if task donothing &> /dev/null; then
    task -vvv start
  else
    FORCE_TASKFILE_UPDATE=true ensureTaskfiles
    if task donothing &> /dev/null; then
      task -vvv start
    else
      # shellcheck disable=SC2016
      logger warn 'Something appears to be wrong with the main Taskfile.yml - resetting to shared common version'
      rm Taskfile.yml
      ensureProjectBootstrapped
    fi
  fi
fi
