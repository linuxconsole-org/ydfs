export YDFS = $(shell git rev-parse --abbrev-ref HEAD)
ARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/sun4u/sparc64/ \
				  -e s/arm.*/arm/ -e s/sa110/arm/ \
				  -e s/s390x/s390/ -e s/parisc64/parisc/ \
				  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
				  -e s/sh[234].*/sh/ )

all: docker-64
mkdir:
	@echo mkdir
	install -d ${HOME}/ydfs
	install -d ${HOME}/${ARCH}
	@echo $(YDFS) > ydfs
	chmod 777 ${HOME}/ydfs
	chmod 777 ${HOME}/${ARCH}

docker-image-64: core/Dockerfile
	cd core && docker build -f Dockerfile -t ydfs64-${YDFS} .
	touch docker-image-64

docker-64: docker-image-64
	docker run -ti --rm --security-opt seccomp=unconfined \
	-v "${HOME}/ydfs:/home/linuxconsole2025/ydfs" \
	-v "${HOME}/${ARCH}:/home/linuxconsole2025/${ARCH}" \
	-v "${PWD}:/ydfs-src" \
	-w="/ydfs-src" \
	-e "HOME_DIBAB=/ydfs-src/core" \
	ydfs64-${YDFS} /bin/sh -c 'cd core; make iso'

bash: mkdir
	docker run -ti --rm --security-opt seccomp=unconfined \
	-v "${HOME}/ydfs:/home/linuxconsole2025/ydfs" \
	-v "${HOME}/${ARCH}:/home/linuxconsole2025/${ARCH}" \
	-v "${PWD}:/ydfs-src" \
	-w="/ydfs-src" \
	-e "HOME_DIBAB=/ydfs-src/core" \
	ydfs64-${YDFS} bash
#	--user $(shell id -u):$(shell id -g) \
#fast-64: mkdir
#	docker run -ti --rm --security-opt seccomp=unconfined \
	-e "BUILDYDFS=fast" \
