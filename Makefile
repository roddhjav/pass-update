#!/usr/bin/make -f
# pass update - Password Store Extension (https://www.passwordstore.org/)
# Copyright (C) 2017-2024 Alexandre PUJOL <alexandre@pujol.io>.
# SPDX-License-Identifier: GPL-3.0-or-later

UNAME := $(shell uname)

EXT ?= update
ifeq ($(UNAME), Darwin)
    BREW_PREFIX := $(shell command -v brew >/dev/null 2>&1 && brew --prefix)
    ifneq ($(BREW_PREFIX),)
        PREFIX ?= $(BREW_PREFIX)
    else
        PREFIX ?= /usr/local
    endif
else
    PREFIX ?= /usr
endif
DESTDIR ?=
LIBDIR ?= $(PREFIX)/lib
MANDIR ?= $(PREFIX)/share/man
SYSTEM_EXTENSION_DIR ?= ${LIBDIR}/password-store/extensions
ifeq ($(UNAME), Darwin)
    BASHCOMPDIR ?= $(PREFIX)/etc/bash_completion.d
else
    BASHCOMPDIR ?= $(PREFIX)/share/bash-completion/completions
endif
ZSHCOMPDIR ?= $(PREFIX)/share/zsh/site-functions

all:
	@echo "pass-${EXT} is a shell script and does not need compilation, it can be simply executed."
	@echo "To install it try \"make install\" instead."

install_share: 
	@install -Dm0644 share/bash-completion/completions/pass-${EXT} "${DESTDIR}${BASHCOMPDIR}/pass-${EXT}"
	@install -Dm0644 share/zsh/site-functions/_pass-${EXT} "${DESTDIR}${ZSHCOMPDIR}/_pass-${EXT}"
ifneq (,$(wildcard ./share/man/man1/pass-${EXT}.1))
	@install -Dm0644 share/man/man1/pass-${EXT}.1 "${DESTDIR}${MANDIR}/man1/pass-${EXT}.1"
endif

install: install_share
	@install -Dm0755 ${EXT}.bash "${DESTDIR}${SYSTEM_EXTENSION_DIR}/${EXT}.bash"
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
	@docker exec --workdir=${BUILDIR} ${CTNAME} lintian
	@docker exec ${CTNAME} bash -c 'mv ~/${PKGNAME}*.* ~/${PKGNAME}'
	@docker exec ${CTNAME} bash -c 'mv ~/pass-${EXT}*.* ~/${PKGNAME}'

release: tests lint docs commitdocs archive

clean:
	@rm -rf debian/.debhelper debian/debhelper* debian/pass-extension-${EXT}* \
		tests/test-results/ tests/gnupg/random_seed debian/files *.deb \
		*.buildinfo *.changes share/__pycache__ \
		share/man/man1/pass-${EXT}.1

.PHONY: install tests $(T) lint docs archive debian release clean
