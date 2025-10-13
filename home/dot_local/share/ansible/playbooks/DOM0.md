# QubesOS Task List

## Articles to Comb

* [Setting up network printer](https://github.com/Qubes-Community/Contents/blob/master/docs/configuration/network-printer.md#steps-to-configure-a-network-printer-in-a-template-vm)
* [VM hardening](https://github.com/tasket/Qubes-VM-hardening/)
* [Misc. scripts including VagrantUp HVMs](https://github.com/unman/stuff)
* [Tails HVM](https://github.com/Qubes-Community/Contents/blob/master/docs/privacy/tails.md)
* [Block split](https://github.com/rustybird/qubes-split-dm-crypt)
* [Docs and guides](https://www.qubes-os.org/doc/)

## Roles to Re-Visit

```
- roles/applications/peek
- roles/system/ssh
- roles/services/sshtarpit
- roles/services/cups
- roles/services/cockpit
- roles/services/cloudflare
- roles/services/nginx
- roles/services/gitlabrunner
- roles/services/samba
- roles/services/tor
- roles/services/googleassistant
- roles/applications/sharex
- roles/applications/autokey
- roles/system/rear
- roles/system/timeshift
- roles/system/ulauncher
```

## Variables Needed for Qubes

```
hostctl_setup: false # Allows switching /etc/hosts profiles
hostsfile_default_loopback: false
install_switchhosts: false
```

## Create Inventory with Qubes Ansible

Run in dom0:

```
ansible localhost --ask-vault-pass -m qubesos -a "command=createinventory"
```
