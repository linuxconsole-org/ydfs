docker:
	docker run -ti --rm --security-opt seccomp=unconfined \
	-v "${HOME}/ydfs:/home/linuxconsole2024/ydfs" \
	--user $(shell id -u):$(shell id -g) \
	-v "${PWD}:/ydfs-src" \
	-w="/ydfs-src" \
	-e "HOME_DIBAB=/ydfs-src/core" \
	yledoare/ydfs-2.10 /bin/sh -c 'cd core; make iso'
fast:
	docker run -ti --rm --security-opt seccomp=unconfined \
	-v "${HOME}/ydfs:/home/linuxconsole2024/ydfs" \
	--user $(shell id -u):$(shell id -g) \
	-v "${PWD}:/ydfs-src" \
	-w="/ydfs-src" \
	-e "HOME_DIBAB=/ydfs-src/core" \
	-e "BUILDYDFS=fast" \
	yledoare/ydfs-2.10 /bin/sh -c 'cd core; make iso'
