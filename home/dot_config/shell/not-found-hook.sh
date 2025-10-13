#!/bin/bash
# @file Command Not Found Hook
# @brief Handles missing command invocations by checking a YAML configuration, installing missing packages, and running them.
# @description
#     This script is designed to handle situations where a command is invoked but is not found on the system.
#     It performs the following actions:
#
#     1. Checks if the command is listed in the `chezmoi/software.yml` configuration file.
#     2. If found, installs the corresponding Homebrew package(s) and runs the command.
#     3. If not found, attempts to identify the missing package using `brew which-formula --explain`.
#     4. If no match is found, it falls back to generating a set of installation instructions using the `sgpt` tool.
#     5. In headless environments, it bypasses `sgpt` and shows an error message.

# Ensure we are using Bash or Zsh
if [[ -z "$BASH_VERSION" && -z "$ZSH_VERSION" ]]; then
  gum log -sl error "This script must be run in a Bash or Zsh shell."
  exit 1
fi

# @description
#     Installs a missing package via Homebrew, using either a single package or an array of packages.
#     The function supports both standard Homebrew packages and macOS-specific Homebrew formulas.
#     It suppresses output during installation to avoid cluttering the terminal.
install_via_brew() {
  local BREW_KEY="$1"
  local COMMAND="$2"

  # Ensure the brew key exists and contains valid values
  if [[ -z "$BREW_KEY" || "$BREW_KEY" == "<" || -z "$COMMAND" ]]; then
    gum log -sl error "No valid Homebrew package found for '$COMMAND'."
    return 1
  fi

  # Check if the brew key is a string or an array
  if [[ "$BREW_KEY" == *","* ]]; then
    # If it's an array, loop through and install each package
    for PKG in $(echo "$BREW_KEY" | tr ',' '\n'); do
      # Suppress output of brew install to keep the script clean
      if [ ! -d "$HOME/.local/var/log/install.doctor" ]; then
        mkdir -p "$HOME/.local/var/log/install.doctor"
      fi
      echo "$PKG" >> "$HOME/.local/var/log/install.doctor/id-not-found-hook-items"
      if ! brew install "$PKG" &>/dev/null; then
        gum log -sl error "Failed to install '$PKG' via Homebrew."
        return 1
      fi
    done
  else
    # Otherwise, install the single package
    if [[ -z "$BREW_KEY" || "$BREW_KEY" == "<" ]]; then
      gum log -sl error "Invalid Homebrew package name for '$COMMAND'."
      return 1
    fi
    if ! brew install "$BREW_KEY" &>/dev/null; then
      gum log -sl error "Failed to install '$BREW_KEY' via Homebrew."
      return 1
    fi
  fi
}

# @description
#     Handles the case where a command is not found in the system. This function:
#
#     1. Searches the `chezmoi/software.yml` configuration file to check if the command is listed with an associated package.
#     2. If found, installs the required package(s) via Homebrew and runs the command.
#     3. If not found in the YAML, it falls back to using the `brew which-formula --explain` command to find the correct package.
#     4. If no suitable package is found, it uses the `sgpt` tool to generate installation instructions.
#     5. In headless environments, it bypasses `sgpt` and shows an error message.
handle_command_not_found() {
  local COMMAND="$1"
  local SOFTWARE_FILE="${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/software.yml"

  # Check if the software list file exists
  if [[ ! -f "$SOFTWARE_FILE" ]]; then
    gum log -sl error "The software list file ($SOFTWARE_FILE) does not exist."
    return 1
  fi

  # Use yq to extract the _bin value and check for the command
  local BIN_VALUE
  BIN_VALUE=$(yq e ".softwarePackages[] | select(._bin == \"$COMMAND\")" "$SOFTWARE_FILE")

  if [[ -n "$BIN_VALUE" ]]; then
    # Extract the 'brew' or 'brew:darwin' key
    local BREW_KEY
    BREW_KEY=$(yq e ".softwarePackages[] | select(._bin == \"$COMMAND\") | .brew" "$SOFTWARE_FILE")

    # Check for the 'brew:darwin' key for macOS-specific packages
    if [[ "$OSTYPE" == "darwin"* ]]; then
      local BREW_DARWIN_KEY
      BREW_DARWIN_KEY=$(yq e ".softwarePackages[] | select(._bin == \"$COMMAND\") | .\"brew:darwin\"" "$SOFTWARE_FILE")
      if [[ -n "$BREW_DARWIN_KEY" ]]; then
        # Install via Homebrew using the macOS-specific key
        if install_via_brew "$BREW_DARWIN_KEY" "$COMMAND"; then
          "$COMMAND" # Run the command after installation
          return 0
        fi
      fi
    fi

    # Fallback to regular brew key if no macOS-specific key
    if [[ -n "$BREW_KEY" ]]; then
      if install_via_brew "$BREW_KEY" "$COMMAND"; then
        "$COMMAND" # Run the command after installation
        return 0
      fi
    fi
  fi

  # If no match found in software list, check with `brew which-formula`
  local BREW_EXPLAIN_OUTPUT
  BREW_EXPLAIN_OUTPUT=$(brew which-formula --explain "$COMMAND" 2>&1)

  if [[ "$BREW_EXPLAIN_OUTPUT" == *"brew install"* ]]; then
    # Extract the package name from the response and install it
    local BREW_PACKAGE_NAME
    BREW_PACKAGE_NAME=$(echo "$BREW_EXPLAIN_OUTPUT" | grep -oE "brew install [^\s]+" | awk '{print $3}')
    if [[ -n "$BREW_PACKAGE_NAME" ]]; then
      if gum spin --spinner dot --title "Installing $BREW_PACKAGE_NAME with Homebrew.." -- brew install "$BREW_PACKAGE_NAME" &>/dev/null; then
        "$COMMAND" # Run the command after installation
        return 0
      else
        gum log -sl error "Failed to install '$BREW_PACKAGE_NAME' via Homebrew."
        return 1
      fi
    fi
  fi

  # Check for headless environment (no terminal interaction)
  if [[ -z "$DISPLAY" && -z "$SSH_TTY" ]]; then
    gum log -sl error "The '$COMMAND' command was not found and could not be loaded."
    return 1
  fi

  # If nothing found, call sgpt to generate install code
  gum log -sl warn "Command not found."
  gum spin --spinner dot --title "Querying ChatGPT for possible solution.." -- SGPT_RESPONSE="$(sgpt "The \`$COMMAND\` command was not found. The system is macOS. Homebrew is already installed. Print the code that would be required to make the command available. Only print the code in the response.")"

  # Print the markdown response using glow
  echo "$SGPT_RESPONSE" | glow -

  # Check if the response includes a block of code
  if echo "$SGPT_RESPONSE" | grep -q '```'; then
    if gum confirm "Do you want to run suggested solution?"; then
      # Extract the code block from the markdown response and run it
      CODE_BLOCK=$(echo "$SGPT_RESPONSE" | sed -n '/```/,/```/p' | sed '1d;$d')
      eval "$CODE_BLOCK"

      # After running the code block, execute the original command
      # Check if the command has multiple lines or is a single line
      if [[ "$COMMAND" == *$'\n'* ]]; then
        # Multiple lines of command
        echo -e "Running original command:\n\`\`\`$COMMAND\`\`\`" | glow -
      else
        # Single line command
        echo "Running original command: \`$COMMAND\`" | glow -
      fi
    fi
  fi
}

# Main hook: invoked when a command is not found
if [ ${#1} -gt 1 ]; then
  if [[ -n "$1" ]]; then
    handle_command_not_found "$1"
  fi
fi
