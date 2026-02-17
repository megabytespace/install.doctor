# Full Disk Access

On macOS, Install Doctor requires Full Disk Access for the terminal application to configure certain system settings and access protected directories. This is a macOS security feature that prevents applications from accessing sensitive user data without explicit permission.

## Why It's Needed

Full Disk Access is required to:

- Modify system preferences and security settings via `defaults write`
- Access files in protected directories like `~/Library/Mail`, `~/Library/Messages`, and `~/Library/Safari`
- Configure system-level services and launch agents
- Import SSL certificates into the System Keychain

## How to Grant Full Disk Access

1. Open **System Settings** (or **System Preferences** on older macOS versions)
2. Navigate to **Privacy & Security** > **Full Disk Access**
3. Click the lock icon and authenticate with your password
4. Click the **+** button
5. Navigate to and select your terminal application:
   - **Terminal.app**: `/Applications/Utilities/Terminal.app`
   - **iTerm2**: `/Applications/iTerm.app`
   - **Warp**: `/Applications/Warp.app`
   - **Alacritty**: `/Applications/Alacritty.app`
6. Ensure the toggle next to your terminal is **enabled**
7. Restart your terminal application

## Headless Mode

When running Install Doctor with `HEADLESS_INSTALL=true`, the full disk access check is skipped with a warning. Some macOS-specific operations may fail in this mode, but the core provisioning process will continue.

## Troubleshooting

If you see errors related to "Operation not permitted" during provisioning on macOS, this typically means Full Disk Access has not been granted. Follow the steps above and re-run the provisioning process.
