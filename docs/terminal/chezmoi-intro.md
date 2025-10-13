# Install Doctor: Multi-OS provisioning made easy

Using this script for the first time? Check out [our documentation](https://install.doctor/docs) for the complete rundown on how you can fork / modify our project to make it your own. Completely headlessly provision your workstations with thousands of useful software packages, integrated into your system via a well-thought secret management engine and meticulous configurations.

## Customizing

Adapting this project for your own purposes basically boils down to a few steps:

1. [Fork our GitHub project](https://github.com/megabyte-labs/install.doctor/fork).
2. Generate an Age encryption key.
3. Use the Age encryption key to populate the secrets in `home/.chezmoitemplates`. For help, check out the [Secrets documentation](https://install.doctor/docs/customization/secrets).
4. Customize the values in `home/.chezmoidata.yaml` and `home/.chezmoi.yaml.tmpl`.

## Headless Deploy

With all that in order, the next time you can headlessly provision your workstation by running:

```shell
export AGE_PASSWORD=YourAgePassword
export START_REPO=GitHubUsername
export SUDO_PASSWORD=YourSudoPassword
bash <(curl -sSL https://install.doctor/start)
```
