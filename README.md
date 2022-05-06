# Prerequisites
- Target machine has to have SSH installed with running user's SSH key installed.
- Ansible controller must have `containers.podman.podman_container` installed. To check it is installed, run `$ ansible-galaxy collection list`.

# Handling an OVA
Just import the OVA-file into VMware. During the import process you can specify the default user's password.
