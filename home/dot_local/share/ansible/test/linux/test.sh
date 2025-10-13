#!/usr/bin/env bash

# @file test/linux/test.sh
# @brief A script used to test Ubuntu ARM on Travis CI and possibly other scenarios

TEST_TYPE='linux'

# @description Ensure Ansible is installed
if ! type ansible &> /dev/null; then
  pip3 install ansible
fi

# @description Ensure Ansible Galaxy dependencies are installed
if [ -f requirements.yml ]; then
  ansible-galaxy install -r requirements.yml
fi

# @description Symlink the Ansible Galaxy role name to the working directory one level up
ROLE_NAME="$(grep "role:" test/linux/test.yml | sed 's^- role: ^^' | xargs)"
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

# @description Back up files, run the play, and then restore files
backupAndCopyFiles
ansible-playbook -i "test/$TEST_TYPE/inventory" test.yml || restoreFilesAndExitError
restoreFiles
