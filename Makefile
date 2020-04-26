PROG ?= update
PREFIX ?= /usr
DESTDIR ?=
LIBDIR ?= $(PREFIX)/lib
MANDIR ?= $(PREFIX)/share/man

SYSTEM_EXTENSION_DIR ?= $(LIBDIR)/password-store/extensions

BASHCOMPDIR ?= $(PREFIX)/share/bash-completion/completions
ZSHCOMPDIR ?= $(PREFIX)/share/zsh/site-functions

all:
	@echo "pass-$(PROG) is a shell script and does not need compilation, it can be simply executed."
	@echo ""
	@echo "To install it try \"make install\" instead."
	@echo

install:
	@install -vd "$(DESTDIR)$(SYSTEM_EXTENSION_DIR)/" "$(DESTDIR)$(MANDIR)/man1" \
				 "$(DESTDIR)$(BASHCOMPDIR)" "$(DESTDIR)$(ZSHCOMPDIR)"
	@install -vm 0755 $(PROG).bash "$(DESTDIR)$(SYSTEM_EXTENSION_DIR)/$(PROG).bash"
	@install -vm 0644 pass-$(PROG).1 "$(DESTDIR)$(MANDIR)/man1/pass-$(PROG).1"
	@install -vm 0644 "completion/pass-$(PROG).bash" "$(DESTDIR)$(BASHCOMPDIR)/pass-$(PROG)"
	@install -vm 0644 "completion/pass-$(PROG).zsh" "$(DESTDIR)$(ZSHCOMPDIR)/_pass-$(PROG)"
	@echo
	@echo "pass-$(PROG) is installed succesfully"
	@echo

uninstall:
	@rm -vrf \
		"$(DESTDIR)$(SYSTEM_EXTENSION_DIR)/$(PROG).bash" \
		"$(DESTDIR)$(MANDIR)/man1/pass-$(PROG).1" \
		"$(DESTDIR)$(ZSHCOMPDIR)/_pass-$(PROG)" \
		"$(DESTDIR)$(BASHCOMPDIR)/pass-$(PROG)"


COVERAGE ?= false
TMP ?= /tmp/pass-update
PASS_TEST_OPTS ?= --verbose --immediate --chain-lint --root=/tmp/sharness
T = $(sort $(wildcard tests/*.sh))
export COVERAGE TMP

tests: $(T)
	@tests/results

$(T):
	@$@ $(PASS_TEST_OPTS)

lint:
	shellcheck --shell=bash $(PROG).bash tests/commons tests/results

clean:
	@rm -vrf debian/.debhelper debian/debhelper* debian/pass-extension-import* \
		tests/test-results/ tests/gnupg/random_seed

.PHONY: install uninstall tests $(T) lint clean
