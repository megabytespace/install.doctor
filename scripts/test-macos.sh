#!/bin/bash
# @file macos-script.sh
# @brief Run a user-specified command inside a macOS GitHub runner.
# @description
#     This script runs inside a macOS GitHub Actions runner and executes
#     a user-provided command.
#
# @usage
#   ./macos-script.sh "your-command-here"
#
# @requires
#   - macOS GitHub runner
#
# @exitcode 0 If successful.
# @exitcode 1 If an error occurs.

set -e

# Redirect output to log file
LOG_FILE="macos-script.log"
exec > >(tee -i "$LOG_FILE") 2>&1

# ==============================================================================
# GLOBAL VARIABLES
# ==============================================================================
USER_COMMAND="$1"

# ==============================================================================
# @description Print macOS system information.
#
# @stdout System details.
# ==============================================================================
printSystemInfo() {
  echo "### macOS System Information ###"
  sw_vers
  uname -a
  sysctl -n machdep.cpu.brand_string
}

# ==============================================================================
# @description Run a user-specified command inside the macOS runner.
#
# @stdout Command output.
#
# @exitcode 0 If successful.
# @exitcode 1 If the command fails.
# ==============================================================================
runUserCommand() {
  if [[ -z "$USER_COMMAND" ]]; then
    echo "Error: No command provided."
    exit 1
  fi

  echo "### Running User Command ###"
  echo "Executing: $USER_COMMAND"
  eval "$USER_COMMAND"
}

# ==============================================================================
# Main Execution
# ==============================================================================
main() {
  printSystemInfo
  runUserCommand
}

main
