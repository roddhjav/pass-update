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

SHARE = $(shell find share/ -not -name "*.md" -type f -printf "%P\n")
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


clean:
	@rm -rf debian/.debhelper debian/debhelper* debian/pass-extension-${EXT}* \
		tests/test-results/ tests/gnupg/random_seed debian/files *.deb \
		*.buildinfo *.changes share/__pycache__

.PHONY: install tests $(T) lint docs commitdocs archive debian release clean
