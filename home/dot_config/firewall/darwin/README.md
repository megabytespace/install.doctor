# macOS Firewall Rules

The macOS firewall rules are derived from the configurations defined in the `etc/firewalld/services/` folder using ChatGPT.

## Example Prompt

```
convert the following FirewallD configuration to commands that can be used to configure the macOS firewall in a similar fashion. Only return a single bash script with no other text and do not enable logging or the firewall. Do not include any text other than the bash script and do not provide instructions or "Here's the bash script" text or "Please note that" text or anything other than script that can be run: <?xml version="1.0" encoding="utf-8"?>
<service>
  <short>Plex</short>
  <description>.</description>
  <port protocol="tcp" port="32400"/> # Plex Media Server
  <port protocol="udp" port="1900"/> # Plex DLNA Server
  <port protocol="tcp" port="32469"/> # Plex DLNA Server
  <port protocol="udp" port="32410"/> # GDM Network Discovery
  <port protocol="udp" port="32412"/> # GDM Network Discovery
  <port protocol="udp" port="32413"/> # GDM Network Discovery
  <port protocol="udp" port="32414"/> # GDM Network Discovery
</service>
```