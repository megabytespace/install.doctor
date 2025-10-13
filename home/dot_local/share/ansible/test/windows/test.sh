#!/usr/bin/env bash

# @file test/windows/test.sh
# @brief A script that is used to test an Ansible role on Windows from a WSL environment (or possibly Docker)
#
# @description This script is intended to be run in a WSL environment on a Windows host to provision the Windows
# host via Ansible using WinRM and CredSSP.

TEST_TYPE='windows'

# @description Ensure Ansible is installed along with required dependencies
if ! type ansible &> /dev/null; then
  pip3 install ansible 'pywinrm[credssp]'
fi

# @description Ensure Ansible Galaxy dependencies are installed
if [ -f requirements.yml ]; then
  ansible-galaxy install -r requirements.yml
fi

# @description Symlink the Ansible Galaxy role name to the working directory one level up
ROLE_NAME="$(grep "role:" test/windows/test.yml | sed 's^- role: ^^' | xargs)"
ln -s "$(basename "$PWD")" "../$ROLE_NAME"

# @description Back up files and then copy replacements
function backupAndCopyFiles() {
  if [ -f ansible.cfg ]; then
    cp ansible.cfg ansible.cfg.bak
  fi
  cp "test/$TEST_TYPE/ansible.cfg" ansible.cfg
  if [ -f test.yml ]; then
    cp test.yml test.yml.bak
  fi
  cp "test/$TEST_TYPE/test.yml" test.yml
}

# @description Restores files that were backed up
function restoreFiles() {
  if [ -f ansible.cfg.bak ]; then
    mv ansible.cfg.bak ansible.cfg
  fi
  if [ -f test.yml.bak ]; then
    mv test.yml.bak test.yml
  fi
}

# @description Calls [restoreFiles] and exits with an error
function restoreFilesAndExitError() {
  restoreFiles
  exit 1
}

# @description Silence error about ansible.cfg being writable
export ANSIBLE_CONFIG="$PWD/ansible.cfg"

# @description Back up files, run the play, and then restore files
backupAndCopyFiles
ansible-playbook -i "test/$TEST_TYPE/inventory" test.yml || restoreFilesAndExitError
restoreFiles
