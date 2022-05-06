# Prerequisites
- Target machine has to have SSH installed with running user's SSH key installed.
- Ansible controller must have `containers.podman.podman_container` installed. To check it is installed, run `$ ansible-galaxy collection list`.

# Handling an OVA
Just import the OVA-file into VMware. During the import process you can specify the default user's password.

# TODO
Add a firewall rule to route traffic from privileged ports to unprivileged ones.
```
- name: Redirect DNS, DHCP, HTTP and HTTPS to pihole
    ansible.posix.firewalld:
    rich_rule: "{{ item }}"
    zone: public
    permanent: true
    immediate: true
    state: "{{ firewall_state }}"
    loop:
    - rule family=ipv4 forward-port port=53 protocol=tcp to-port=1153
    - rule family=ipv4 forward-port port=53 protocol=udp to-port=1153
    - rule family=ipv4 forward-port port=67 protocol=udp to-port=1167
    - rule family=ipv4 forward-port port=80 protocol=tcp to-port=1180
    - rule family=ipv4 forward-port port=443 protocol=tcp to-port=1443
```