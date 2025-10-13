# Postfix

**Configures Postfix to use SendGrid as a relay host**

This configuration file is appended to `/etc/postfix/main.cf` by one of the scripts. It configures SendGrid as a relay host that Postfix can use. More details can be found in the [SendGrid documentation on integrating Postfix](https://docs.sendgrid.com/for-developers/sending-email/postfix). Some FROM addresses do not work properly when using SendGrid. Because of this, the configuration will automatically re-write the FROM address to equal `system@public.domain.com`, where `public.domain.com` is the value specified under `.host.domain` in `~/.config/chezmoi/chezmoi.yml`.