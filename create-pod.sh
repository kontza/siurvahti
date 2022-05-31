podman pod create \
	--dns '127.0.0.1'\
	--dns '192.168.1.43' \
	--replace \
	--name pod \
	--publish=10053:53/udp \
	--publish=10053:53/tcp \
	--publish=10080:80/tcp
