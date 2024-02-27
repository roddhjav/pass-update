#!/usr/bin/make -f
# pass update - Passwords importer swiss army knife
# Copyright (C) 2017-2024 Alexandre PUJOL <alexandre@pujol.io>.
# SPDX-License-Identifier: GPL-3.0-or-later

EXT ?= update
PREFIX ?= /usr
DESTDIR ?=
LIBDIR ?= ${PREFIX}/lib
SYSTEM_EXTENSION_DIR ?= ${LIBDIR}/password-store/extensions

all:
	@echo "pass-${EXT} is a shell script and does not need compilation, it can be simply executed."
	@echo ""
	@echo "To install it try \"make install\" instead."
	@echo

SHARE = $(shell find share/ -not -name "*.md" -not -name "*.py" -type f -printf "%P\n")
install:
	@install -Dm0755 ${EXT}.bash "${DESTDIR}${SYSTEM_EXTENSION_DIR}/${EXT}.bash"
	@for file in ${SHARE}; do \
		install -Dm0644 "share/$${file}" "${DESTDIR}/${PREFIX}/share/$${file}"; \
    done;
	@echo "pass-${EXT} is installed succesfully"

COVERAGE ?= false
TMP ?= /tmp/tests/pass-update
PASS_TEST_OPTS ?= --verbose --immediate --chain-lint --root=/tmp/sharness
T = $(sort $(wildcard tests/*.sh))
export COVERAGE TMP
tests: $(T)
	@tests/results

$(T):
	@$@ $(PASS_TEST_OPTS)

lint:
	shellcheck --shell=bash ${EXT}.bash tests/commons tests/results

docs:
	@pandoc -t man -s -o share/man/man1/pass-${EXT}.1 share/man/man1/pass-${EXT}.md

OLDVERSION ?=
VERSION ?=
GPGKEY ?= 06A26D531D56C42D66805049C5469996F0DF68EC
archive:
	@python3 share --release ${OLDVERSION} ${VERSION}
	@git tag v${VERSION} -m "pass-${EXT} v${VERSION}" --local-user=${GPGKEY}
	@git archive \
		--format=tar.gz \
		--prefix=pass-${EXT}-${VERSION}/share/man/man1/ \
		--add-file=share/man/man1/pass-${EXT}.1 \
		--prefix=pass-${EXT}-${VERSION}/ \
		--output=pass-${EXT}-${VERSION}.tar.gz \
		v${VERSION} ':!debian' ':!share/man/man1/*.md'
	@gpg --armor --default-key ${GPGKEY} --detach-sig pass-${EXT}-${VERSION}.tar.gz
	@gpg --verify pass-${EXT}-${VERSION}.tar.gz.asc

PKGNAME := pass-extension-${EXT}
BUILDIR := /home/build/${PKGNAME}
BASEIMAGE := registry.gitlab.com/roddhjav/builders/debian
CTNAME := builder-debian-pass-${EXT}
debian:
	@docker stop ${CTNAME} &> /dev/null || true
	@docker pull ${BASEIMAGE}
	@docker run --rm -tid --name ${CTNAME} --volume ${PWD}:${BUILDIR} \
		--volume ${HOME}/.gnupg:/home/build/.gnupg ${BASEIMAGE} &> /dev/null || true
	@docker exec --workdir=${BUILDIR} ${CTNAME} \
		dpkg-buildpackage -b -d -us -ui --sign-key=${GPGKEY}
	@docker exec ${CTNAME} bash -c 'mv ~/${PKGNAME}*.* ~/${PKGNAME}'
	@docker exec ${CTNAME} bash -c 'mv ~/pass-${EXT}*.* ~/${PKGNAME}'

release: tests lint docs commitdocs archive

clean:
	@rm -rf debian/.debhelper debian/debhelper* debian/pass-extension-${EXT}* \
		tests/test-results/ tests/gnupg/random_seed debian/files *.deb \
		*.buildinfo *.changes share/__pycache__

.PHONY: install tests $(T) lint docs archive debian release clean
