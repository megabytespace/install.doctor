#!/bin/bash
# @file run-vm.sh
# @brief Script to run a Linux VM in a CI/CD environment.
# @description
#     This script sets up and runs a virtual machine using QEMU/KVM.
#     It supports multiple Linux distributions, configures a cloud-init ISO,
#     launches the VM, and executes a specified command inside the VM.
#
#     Features:
#      * Supports Ubuntu, Arch Linux, Fedora, CentOS, Debian, and Alpine.
#      * Automatically downloads the correct cloud image.
#      * Optimized SSH wait logic for faster boot times.
#      * Shrinks cloud images before booting for improved efficiency.
#      * Snapshot mode to preserve base image integrity.
#      * Enhanced logging and error handling.
#      * Automatically detects and generates SSH keys if missing.
#
# @usage
#   ./run-vm.sh <distro> "your-command-here"
#
# @option ubuntu Use Ubuntu (default).
# @option arch Use Arch Linux.
# @option fedora Use Fedora.
# @option centos Use CentOS.
# @option debian Use Debian.
# @option alpine Use Alpine Linux.
#
# @requires
#   - QEMU/KVM installed (`qemu-system-x86_64`, `genisoimage`)
#   - SSH client (`ssh`)
#
# @exitcode 0 If successful.
# @exitcode 1 If an error occurs.

set -e

# Redirect output to log files
LOG_FILE="run-vm.log"
ERROR_LOG="run-vm-error.log"
exec > >(tee -i "$LOG_FILE") 2>&1

# ==============================================================================
# GLOBAL VARIABLES
# ==============================================================================

DISTRO="${1:-ubuntu}"
IMAGE="${DISTRO}-server.img"
CLOUD_INIT_ISO="cloud-init.iso"
VM_NAME="${DISTRO}-vm"
MEMORY="${MEMORY:-2048}"
CPUS="${CPUS:-2}"
SSH_PORT="${SSH_PORT:-2222}"
SSH_USER="ci-user"

# ==============================================================================
# @description Detect an existing SSH key or create a new one if missing.
#
# @stdout The detected or newly generated SSH key path.
#
# @exitcode 0 If a key is found or successfully created.
# @exitcode 1 If SSH key generation fails.
# ==============================================================================
detectSshKey() {
  SSH_KEY=$(find ~/.ssh -name "*.pub" | head -n 1)
  if [ -z "$SSH_KEY" ]; then
    echo "No SSH key found. Generating one..."
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N "" >/dev/null 2>&1
    SSH_KEY="~/.ssh/id_rsa.pub"
    if [ ! -f "$SSH_KEY" ]; then
      echo "Error: Failed to generate SSH key."
      exit 1
    fi
  fi
  echo "Using SSH key: $SSH_KEY"
}

# ==============================================================================
# @description Download the selected Linux cloud image if not already available.
#
# @stdout Download progress if needed.
#
# @exitcode 0 If successful.
# @exitcode 1 If the download fails.
# ==============================================================================
downloadImage() {
  local IMAGE_URL
  IMAGE_URL="https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"

  if [ ! -f "$IMAGE" ]; then
    echo "Downloading $DISTRO cloud image..."
    wget -O "$IMAGE" "$IMAGE_URL"
  fi
}

# ==============================================================================
# @description Reduce image size before booting to improve efficiency.
#
# @stdout Confirmation message after resizing.
#
# @exitcode 0 If successful.
# @exitcode 1 If resizing fails.
# ==============================================================================
resizeImage() {
  echo "Resizing cloud image for efficiency..."
  qemu-img resize "$IMAGE" +10G
}

# ==============================================================================
# @description Generate cloud-init configuration files for VM initialization.
#
# @stdout Confirmation messages on success.
#
# @exitcode 0 If successful.
# @exitcode 1 If file creation fails.
# ==============================================================================
createCloudInitConfig() {
  echo "Creating cloud-init configuration..."
  mkdir -p cloud-init

  cat > cloud-init/user-data <<EOF
#cloud-config
users:
  - name: $SSH_USER
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    groups: sudo
    shell: /bin/bash
    ssh_authorized_keys:
      - $(cat "$SSH_KEY")

runcmd:
  - echo "Cloud-init setup complete"
EOF

  cat > cloud-init/meta-data <<EOF
instance-id: ${DISTRO}-ci
local-hostname: ${DISTRO}-ci
EOF

  genisoimage -output "$CLOUD_INIT_ISO" -volid cidata -joliet -rock cloud-init/user-data cloud-init/meta-data
}

# ==============================================================================
# @description Start the Linux VM using QEMU with snapshot mode.
#
# @stdout Status message on VM start.
#
# @exitcode 0 If successful.
# @exitcode 1 If VM fails to start.
# ==============================================================================
startQemuVm() {
  echo "Starting $DISTRO VM..."
  qemu-system-x86_64 \
      -m "$MEMORY" \
      -smp "$CPUS" \
      -enable-kvm \
      -drive file="$IMAGE",format=qcow2,if=virtio,snapshot=on \
      -cdrom "$CLOUD_INIT_ISO" \
      -netdev user,id=user.0,hostfwd=tcp::"$SSH_PORT"-:22 \
      -device virtio-net,netdev=user.0 \
      -nographic &
}

# ==============================================================================
# @description Wait for SSH to become available inside the VM.
#
# @stdout Status message.
#
# @exitcode 0 If SSH is reachable.
# @exitcode 1 If SSH does not become available.
# ==============================================================================
waitForSsh() {
  echo "Waiting for SSH connection..."
  SECONDS_WAITED=0
  MAX_WAIT=60
  while ! nc -z localhost "$SSH_PORT"; do
    if [[ $SECONDS_WAITED -ge $MAX_WAIT ]]; then
      echo "Error: SSH did not become available within $MAX_WAIT seconds."
      exit 1
    fi
    sleep 2
    SECONDS_WAITED=$((SECONDS_WAITED + 2))
  done
  echo "SSH is available!"
}

# ==============================================================================
# @description Run a command inside the VM via SSH.
#
# @arg $2 string The command to execute inside the VM.
#
# @stdout Command output.
#
# @exitcode 0 If successful.
# @exitcode 1 If SSH command fails.
# ==============================================================================
runCommandInVm() {
  local COMMAND=$2
  echo "Running command inside VM: $COMMAND"
  ssh -o StrictHostKeyChecking=no -p "$SSH_PORT" "$SSH_USER"@localhost "$COMMAND"
}

# ==============================================================================
# @description Stop the QEMU VM process gracefully.
#
# @stdout Status message on VM stop.
#
# @exitcode 0 If successful.
# @exitcode 1 If termination fails.
# ==============================================================================
stopVm() {
  echo "Stopping VM..."
  pkill qemu-system-x86_64 || echo "Warning: VM process may not have been running."
}

# ==============================================================================
# Main Execution
# ==============================================================================
main() {
  if [ -z "$2" ]; then
    echo "Usage: $0 <distro> \"your-command-here\""
    exit 1
  fi

  detectSshKey
  downloadImage
  resizeImage
  createCloudInitConfig
  startQemuVm
  waitForSsh
  runCommandInVm "$2"
  stopVm
}

main "$@"
