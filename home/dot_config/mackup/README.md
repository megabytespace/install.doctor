# Application Settings Backup

The command-line utility [`mackup`](https://github.com/lra/mackup) provides a decent starting point to enable Install Doctor to provide the capability of backing up personalized application settings. `mackup` has a shortcoming though. It was not designed to accompany configurations that end up being stored in different places on different operating systems / package managers.

## Mackup

For this reason, we use `mackup` to handle the back-up and restore of the "golden" copy of application settings which will usually be stored in the `~/.config` directory. In some cases, we can get away with, for example, symlinking the `~/.config/ABC` to `~/Library/Application Settings/ABC`. But, in other cases like Flatpak, we need to keep the Flatpak configuration stored under `~/.var/com.abc.XYZ` synchronized with `~/.config/ABC`.

## `software.yml` Application Setting Definitions

The `mackup` configurations will handle the backing up of the "golden" copy and the technical package manager specific linking / synchronization is handled by our CLI. If you browse through the `software.yml` file, you will see something like the following which provides enough details to our CLI to handle the technical details:

```yaml
  google-chrome:
    _name: Google Chrome
    _app: Google Chrome.app
    _link:cask:
      - src: "${XDG_CONFIG_HOME:-$HOME/.config}/google-chrome/Default"
        target: "$HOME/Library/Application Support/Google/Chrome/Default"
    _link:choco: 'TODO'
    _link:flatpak:
      - src: "${XDG_CONFIG_HOME:-$HOME/.config}/google-chrome/Default"
        target: "$HOME/.var/app/com.google.Chrome/config/google-chrome/Default"
    cask: google-chrome
    choco: googlechrome
    flatpak: com.google.Chrome
    yay: google-chrome
```

The keys that start with `_link` add the instructions necessary to synchronize the configurations amongst the various possible locations in the most efficient manner. The `cask` and `flatpak` have their definitions in place. The `choco` still needs some work. And the `yay` option needs no definition because the configuration is already in the proper place by default for unrestricted system package managers.

It also is important to note that the `mackup` configuration for each app (in the `~/.config/mackup/.mackup` folder) should be named using the object ID you can find for each application in the `software.yml` file.

## `backup-apps` Script

On a side note, once the proper application definitions are in place in the `software.yml` file and the proper configurations are made in this folder's `.mackup` folder, then you can use our convienience script located at `~/.local/bin/backup-apps` to perform the backup. It was created to avoid having to leave a `~/.mackup` folder and a `~/.mackup.cfg` file in the home directory.

## Example

[This commit](https://github.com/megabyte-labs/install.doctor/commit/5f3466a304bcd1c14d44557a30bcc980fe31db65) provides a clear example of the type of code that is necessary to adapt the `software.yml` and `~/.config/mackup` configurations.

## TODO

We need to go through the `software.yml` file and figure out which applications would benefit from application setting synchronization. Basically, any application that has `cask` and `flatpak` options will need to be configured. It is possible that some settings might reside outside of `~/Library/Application Support`.

For now, the `choco` definitions should use Unix style forward slash definitions along with `%APPDATA%` to define the location of the settings.
