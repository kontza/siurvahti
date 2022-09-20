# Missä mennään?

# Debian alkuvalmistelut
Ao. lista päti ainakin Debian 11:n asennuksen aikaan.
1. Kopioi SSH-avain luodulle käyttäjälle, jotta Ansiblella saa otettua yhteyden ilman salasanaa.
2. Pitääkö `pip install hvac`?

# Järjestelmät

## Siurvahti

## Kaivoskarhu

## Otsonkolo
1. [ ] Mount RAID.
2. [ ] Timezone.
3. [ ] Keymap.
4. [ ] Add otsonkolo.users.
5. [ ] Samba
6. [ ] VDR
7. [ ] Paper MC; käytä https://github.com/kontza/minecraft-ansible
8. [ ] Bitwarden-setti
   1. [ ] Caddy v2
   2. [ ] Vaultwarden
   3. [ ] PostgreSQL
   4. [ ] Grafana
9. [ ] Ajastukset:
   1. [ ] pip-upgrader.service
   2. [ ] dy-fi-updater.service
   3. [ ] wol_worker.service
   4. [ ] dr-who.service


# Ansible Podman vs CLI
When creating a pod and a container via CLI, and generating systemd unit files for those, Pi-hole works.
For some reason, when created via Ansible, they don't work. To be precise, they start up, but don't respond to DNS queries from the outside.
Perhaps I should raise an issue with the Ansible Podman team. At least just to get an answer as to why this happens.

# Handling an OVA
Just import the OVA-file into VMware. During the import process you can specify the default user's password.

# A Hindsight Note About Redirection
Remember that short hostname on a fresh Ubuntu install may point to `127.0.1.1`. This tripped me propertly when I tried to validate my rules. I have a simple TCP-listener app (github.com/kontza/ideal-doodle), that I used to spring up a listener `$ ./ideal-doodle -a shorthostname:10080`. Then I tried `$ echo -n (date)|nc shorthostname:10080`. And wondered why it doesn't work. Then I tried the simple HTTP server from Python3: `$ python3 -mhttp.server --bind shorthostname 10080`, and then I noticed that the full address the server was listening to was `127.0.1.1:10080`. Once that came up, I understood why my rules weren't triggering, and how to remedy that.

# Steps to get 80 -> 10080 working on localhost, too
1. Allow SSH from local network:<br>
   ```
   $ sudo ufw allow proto tcp from 192.168.1.0/16 to any port 22,80,10080
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
   -A POSTROUTING -s 192.168.1.0/16 ! -d 192.168.1.0/16 -j MASQUERADE
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
