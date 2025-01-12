export YDFS = $(shell git rev-parse --abbrev-ref HEAD)
ARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/sun4u/sparc64/ \
				  -e s/arm.*/arm/ -e s/sa110/arm/ \
				  -e s/s390x/s390/ -e s/parisc64/parisc/ \
				  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
				  -e s/sh[234].*/sh/ )

ISTTY = $(shell tty -s || echo NOTTY)

ifeq ($(ISTTY),NOTTY)
	OPTION=
else
	OPTION=-ti
endif

DOCKER=docker run ${OPTION} --rm --security-opt seccomp=unconfined \
	-v ${HOME}/ydfs:/home/linuxconsole2025/ydfs \
	-v ${HOME}/${ARCH}:/home/linuxconsole2025/${ARCH} \
	-v ${HOME}/archpkg:/home/linuxconsole2025/archpkg \
	-v ${PWD}:/ydfs-src \
	-w=/ydfs-src \
	-e HOME_DIBAB=/ydfs-src/core \
	-e SEND_BUILD_LOG=YES

all: docker-64

clean:
	rm -fR ${HOME}/ydfs
	rm -fR ${HOME}/${ARCH}
mkdir:
	@echo mkdir
	install -d ${HOME}/ydfs
	install -d ${HOME}/archpkg
	install -d ${HOME}/${ARCH}
	@echo $(YDFS) > ydfs
	chmod 777 ${HOME}/ydfs
	chmod 777 ${HOME}/archpkg
	chmod 777 ${HOME}/${ARCH}

docker-image-64: core/Dockerfile
	cd core && docker build -f Dockerfile -t ydfs64-${YDFS} .
	touch docker-image-64

docker-64: docker-image-64 mkdir
	${DOCKER} ydfs64-${YDFS} /bin/sh -c 'cd core; make iso'

buildme:
	${DOCKER} -e BUILDME=OK ydfs64-${YDFS} /bin/sh -c 'cd core; make iso'

uninstall:
	${DOCKER} ydfs64-${YDFS} /bin/sh -c 'cd core; scripts/uninstall-package dbus-1.16.0'

bash: mkdir
	${DOCKER} ydfs64-${YDFS} bash

root: mkdir
	${DOCKER} -u root ydfs64-${YDFS} bash

fast-64: mkdir
	${DOCKER} ydfs64-${YDFS} -e "BUILDYDFS=fast" /bin/sh -c 'cd core; make iso'

initramfs:
	${DOCKER} ydfs64-${YDFS} /bin/sh -c 'cd core; make initramfs'

#	--user $(shell id -u):$(shell id -g) \
