podman create \
	--cap-add CAP_NET_RAW \
	--cap-add CAP_NET_ADMIN \
	--cap-add CAP_SYS_NICE \
	--pod pod-pihole-unbound \
	--env TZ='Europe/Helsinki' \
	--env WEBPASSWORD='Atlas-Breath-Anthology-Dingy-Uncombed-Illusive' \
	--name container-pihole \
	docker.io/pihole/pihole
