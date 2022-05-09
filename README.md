# Prerequisites
- Target machine has to have SSH installed with running user's SSH key installed.
- Ansible controller must have `containers.podman.podman_container` installed. To check if it is installed, run `$ ansible-galaxy collection list`.

# Handling an OVA
Just import the OVA-file into VMware. During the import process you can specify the default user's password.

# A Hindsight Note About Redirection
Remember that short hostname on a fresh Ubuntu install may point to `127.0.1.1`. This tripped me propertly when I tried to validate my rules. I have a simple TCP-listener app (github.com/kontza/ideal-doodle), that I used to spring up a listener `$ ./ideal-doodle -a shorthostname:10080`. Then I tried `$ echo -n (date)|nc shorthostname:10080`. And wondered why it doesn't work. Then I tried the simple HTTP server from Python3: `$ python3 -mhttp.server --bind shorthostname 10080`, and then I noticed that the full address the server was listening to was `127.0.1.1:10080`. Once that came up, I understood why my rules weren't triggering, and how to remedy that.