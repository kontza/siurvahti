podman create \
	--cap-add CAP_NET_RAW \
	--cap-add CAP_NET_ADMIN \
	--cap-add CAP_SYS_NICE \
	--env TZ='Europe/Helsinki' \
	--env WEBPASSWORD='e_inutile' \
	--replace \
	--name pihole \
	docker.io/pihole/pihole
#       --volume ./pihole/:/etc/pihole:z \
#       --volume ./dnsmasq/:/etc/dnsmasq.d:z \
