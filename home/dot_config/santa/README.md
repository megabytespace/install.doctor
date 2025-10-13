# Santa

Santa is a macOS security tool that helps handle the process of authorizing binary executions.

The `.mobileconfig` files in this folder have to be manually clicked on to be loaded or used in conjunction with an managed device provider. For more information on what each `.mobileconfig` does, please see the [Santa Getting Started](https://santa.dev/deployment/getting-started.html) page.

- `local.santa.mobileconfig` - Does not configure Santa to use a centralized server and can be run locally
- `server.santa.mobileconfig` - Relies on a synchronization server (more details on the [Santa site](https://santa.dev))

The original code used to deploy Santa via Ansible can be seen below which shows how to use `santactl` locally to block apps from loading:

```yaml
---
- name: 'Ensure {{ app_name }} is installed'
  become: false
  community.general.homebrew_cask:
    name: santa
    state: "{{ app_state | default('present') }}"
    accept_external_apps: '{{ allow_external_apps | default(true) }}'
    sudo_password: '{{ ansible_password | default(omit) }}'

- name: Copy the MDM Profile to the target
  become: false
  copy:
    src: santa.mobileconfig
    dest: ~/santa.mobileconfig
    mode: 0700
  when: lockdown_mode

# The `profiles` command, starting in BigSur, does not allow installing Profiles. The command used below allows
# partial automation, in that a notification is shown to install the Profile using System Preferences.
# However, the step fails. Leaving it here to use if another way to completely automate this is possible
# - name: Install the profile # noqa 303
#   shell: open /System/Library/PreferencePanes/Profiles.prefPane /Users/{{ ansible_user }}/santa.mobileconfig
#   when: lockdown_mode
#
# - name: Remove the MDM Profile from the target
#   become: false
#   file:
#     path: ~/santa.mobileconfig
#     state: absent
#   when: lockdown_mode

- name: Ensure Rules are created # noqa 301 305
  shell: /usr/local/bin/santactl rule {{ '--allow' if lockdown_mode else '--block' }} --path {{ rule }}
  loop: '{{ allowed_apps if lockdown_mode else blocked_apps }}'
  loop_control:
    label: '{{ rule }}'
    loop_var: rule
```
