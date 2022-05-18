# Prerequisites
- Target machine has to have SSH installed with running user's SSH key installed.
- Preferrably a non-minimized Ubuntu installed on the target.
- Ansible controller must have `containers.podman.podman_container` installed. To check if it is installed, run `$ ansible-galaxy collection list`.
- You have installed the supporting collection, `kontza.server_setup_helpers`, by running
   ```
   ➤ ansible-galaxy collection install -r requirements.yml -U
   ```

# Handling an OVA
Just import the OVA-file into VMware. During the import process you can specify the default user's password.

# A Hindsight Note About Redirection
Remember that short hostname on a fresh Ubuntu install may point to `127.0.1.1`. This tripped me propertly when I tried to validate my rules. I have a simple TCP-listener app (github.com/kontza/ideal-doodle), that I used to spring up a listener `$ ./ideal-doodle -a shorthostname:10080`. Then I tried `$ echo -n (date)|nc shorthostname:10080`. And wondered why it doesn't work. Then I tried the simple HTTP server from Python3: `$ python3 -mhttp.server --bind shorthostname 10080`, and then I noticed that the full address the server was listening to was `127.0.1.1:10080`. Once that came up, I understood why my rules weren't triggering, and how to remedy that.

# Steps to get 80 -> 10080 working on localhost, too
1. Allow SSH from local network:<br>
   ```
   $ sudo ufw allow proto tcp from 192.168.1.0/24 to any port 22,80,10080
   ```
1. Edit `/etc/default/ufw`:
   ```
   DEFAULT_FORWARD_POLICY="ACCEPT"
   MANAGE_BUILTINS=yes # It seems, that this can be left at 'no'.
   ```
1. Edit `/etc/ufw/sysctl.conf`:
   ```
   net/ipv4/ip_forward=1
   net/ipv6/conf/default/forwarding=1
   ```
1. Add the following to the `/etc/ufw/before.rules`, before `*filter`:
   ```
   *nat
   -A PREROUTING -i ens33 -p tcp --dport 80 -j DNAT --to :10080
   -A POSTROUTING -s 192.168.1.0/24 ! -d 192.168.1.0/24 -j MASQUERADE
   -A OUTPUT -o lo -p tcp --dport 80 -j REDIRECT --to-port 10080
   COMMIT
   ```
1. Copy *ideal-doodle-linux-amd64* to target host, and start it:
   ```
   $ ./ideal-doodle-linux-amd64 -a 0.0.0.0:10080
   ```
1. On the target host, in another _tmux_ window, run:
   ```
   $ echo -n $(date)|nc -v hostname 80
   ```
1. The above should work.
1. Most of the steps were adapted from https://ubuntu.com/server/docs/security-firewall. The decisive fix from access from the same host was from an answer to "_Redirect port 80 to 8080 and make it work on local machine_", https://askubuntu.com/a/579540/828214.

# Sending mail
Kopioi ratkaisu otsonkololta.