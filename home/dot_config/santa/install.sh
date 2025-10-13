#!/usr/bin/env bash
# @file Santa Post-Installation Script
# @brief Installs various profiles that give Santa the permissions it needs to function.
# @description
#     This script opens all the profiles required for a full Santa installation. It relies on having launched a Santa synchronization
#     server. If you do not have a Santa synchronization server, you can launch Santa using the `local.santa.mobileconfig` file
#     which launches Santa in local mode. This mode is not recommended for production use.

open /System/Library/PreferencePanes/Profiles.prefPane "${XDG_CONFIG_HOME:-$HOME/.config}/santa/server.santa.mobileconfig"
open /System/Library/PreferencePanes/Profiles.prefPane "${XDG_CONFIG_HOME:-$HOME/.config}/santa/tcc.configuration-profile-policy.santa.mobileconfig"
open /System/Library/PreferencePanes/Profiles.prefPane "${XDG_CONFIG_HOME:-$HOME/.config}/santa/system-extension-policy.santa.mobileconfig"
open /System/Library/PreferencePanes/Profiles.prefPane "${XDG_CONFIG_HOME:-$HOME/.config}/santa/notification-settings.santa.mobileconfig"