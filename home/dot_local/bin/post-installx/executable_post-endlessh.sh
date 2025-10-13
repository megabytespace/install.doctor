#!/usr/bin/env bash
# @file Endlessh Configuration
# @brief Applies the Endlessh configuration and starts the service on Linux systems

set -Eeo pipefail
trap "gum log -sl error 'Script encountered an error!'" ERR

function configureEndlessh() {
  ### Update the service configuration file
  gum log -sl info 'Updating endlessh service configuration file'
  sudo sed -i 's/^.*#AmbientCapabilities=CAP_NET_BIND_SERVICE/AmbientCapabilities=CAP_NET_BIND_SERVICE/' /usr/lib/systemd/system/endlessh.service
  sudo sed -i 's/^.*PrivateUsers=true/#PrivateUsers=true/' /usr/lib/systemd/system/endlessh.service
  gum log -sl info 'Reloading systemd' && sudo systemctl daemon-reload

  ### Update capabilities of `endlessh`
  gum log -sl info 'Updating capabilities of endlessh' && sudo setcap 'cap_net_bind_service=+ep' /usr/bin/endlessh

  ### Restart / enable Endlessh
  gum log -sl info 'Enabling the endlessh service' && sudo systemctl enable endlessh
  gum log -sl info 'Restarting the endlessh service' && sudo systemctl restart endlessh
}

### Update /etc/endlessh/config if environment is not WSL
if [[ ! "$(test -d proc && grep Microsoft /proc/version > /dev/null)" ]]; then
  if command -v endlessh > /dev/null; then
    if [ -d /etc/endlessh ]; then
      gum log -sl info 'Copying ~/.ssh/endlessh/config to /etc/endlessh/config' && sudo cp -f "$HOME/.ssh/endlessh/config" /etc/endlessh/config
      configureEndlessh || CONFIGURE_EXIT_CODE=$?
      if [ -n "${CONFIGURE_EXIT_CODE:-}" ]; then
        gum log -sl error 'Configuring endlessh service failed' && exit 1
      else
        gum log -sl info 'Successfully configured endlessh service'
      fi
    elif [ -f /etc/endlessh.conf ]; then
      gum log -sl info 'Copying ~/.ssh/endlessh/config to /etc/endlessh.conf' && sudo cp -f "$HOME/.ssh/endlessh/config" /etc/endlessh.conf
      configureEndlessh || CONFIGURE_EXIT_CODE=$?
      if [ -n "${CONFIGURE_EXIT_CODE:-}" ]; then
        gum log -sl error 'Configuring endlessh service failed' && exit 1
      else
        gum log -sl info 'Successfully configured endlessh service'
      fi
    else
      gum log -sl warn 'Neither the /etc/endlessh folder nor the /etc/endlessh.conf file exist'
    fi
  else
    gum log -sl info 'Skipping Endlessh configuration because the endlessh executable is not available in the PATH'
  fi
else
  gum log -sl info 'Skipping Endlessh configuration since environment is WSL'
fi
