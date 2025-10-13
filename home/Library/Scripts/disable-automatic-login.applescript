#!/usr/bin/osascript
-- AppleScript to set Security settings "Disable automatic login" unchecked
# @file Disable macOS Automatic Login
# @brief Disables macOS automatic login via AppleScript
# @description
#     This script disables the macOS automatic login feature in the system settings. The script was found
#     on [StackOverflow](https://apple.stackexchange.com/questions/307482/enabling-automatic-login-via-terminal).

tell application "System Events"
    tell security preferences
        set properties to { automatic login: true }
    end tell
end tell