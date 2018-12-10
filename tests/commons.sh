#!/usr/bin/env bash
# pass update - Password Store Extension (https://www.passwordstore.org/)
# Copyright (C) 2017 Alexandre PUJOL <alexandre@pujol.io>.
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# This file should be sourced by all test-scripts
#
# This scripts sets the following:
#   $PASS	Full path to password-store script to test
#   $GPG	Name of gpg executable
#   $KEY{1..5}	GPG key ids of testing keys
#   $TEST_HOME	This folder
#

# shellcheck disable=SC1091

# Project directory
TESTS_HOME="$(pwd)"
PROJECT_HOME="$(dirname "$TESTS_HOME")"


# Check dependencies
_die() { echo "${@}" && exit 1; }
PASS="$(command -v pass)"; GPG="$(command -v gpg)"; GIT=false
[[ -e "$PASS" ]] || _die "Could not find pass command"
[[ -e "$GPG" ]] || _die "Could not find gpg command"
if $COVERAGE; then
	KCOV="$(command -v kcov)"
	[[ -e "$KCOV" ]] || _die "Could not find kcov command"
	_pass() {
		"$KCOV" --exclude-line='clip "$(echo,esac done' \
		        --include-path="$PROJECT_HOME/update.bash" \
		        "$TMP/$(basename $0)" "$PASS" "${@}"
	}
else
	_pass() { "$PASS" "${@}"; }
fi


# sharness config
export SHARNESS_TEST_DIRECTORY="$TESTS_HOME"
export SHARNESS_TEST_SRCDIR="$PROJECT_HOME"
source ./sharness


#  Prepare pass config vars
unset PASSWORD_STORE_DIR
unset PASSWORD_STORE_KEY
unset PASSWORD_STORE_GIT
unset PASSWORD_STORE_GPG_OPTS
unset PASSWORD_STORE_X_SELECTION
unset PASSWORD_STORE_CLIP_TIME
unset PASSWORD_STORE_UMASK
unset PASSWORD_STORE_GENERATED_LENGTH
unset PASSWORD_STORE_CHARACTER_SET
unset PASSWORD_STORE_CHARACTER_SET_NO_SYMBOLS
unset PASSWORD_STORE_ENABLE_EXTENSIONS
unset PASSWORD_STORE_EXTENSIONS_DIR
unset PASSWORD_STORE_SIGNING_KEY
unset GNUPGHOME
unset EDITOR

export PASSWORD_STORE_ENABLE_EXTENSIONS=true
export PASSWORD_STORE_EXTENSIONS_DIR="$PROJECT_HOME"


# GnuPG config
unset GPG_AGENT_INFO
export GNUPGHOME="$TESTS_HOME/gnupg/"
export KEY1="D4C78DB7920E1E27F5416B81CC9DB947CF90C77B"
export KEY2="70BD448330ACF0653645B8F2B4DDBFF0D774A374"
export KEY3="62EBE74BE834C2EC71E6414595C4B715EB7D54A8"
export KEY4="9378267629F989A0E96677B7976DD3D6E4691410"
export KEY5="4D2AFBDE67C60F5999D143AFA6E073D439E5020C"
chmod 700 "$GNUPGHOME"


# Test helpers

pass_insert() {
	echo -e "$2\nlogin: zx2c4" | pass insert --multiline --force "$1"
}

test_pass_populate() {
	pass init "$KEY1"
	if $GIT; then
		git config --global user.email "Pass-Automated-Testing-Suite@zx2c4.com"
		git config --global user.name "Pass Automated Testing Suite"
		pass git init
	fi
	pass_insert "Business/site.com" "$RANDOM"
	pass_insert "Business/site.eu" "$RANDOM"
	pass_insert "Business/bitcoin/login" "$RANDOM"
	pass_insert "Business/bitcoin/username" "$RANDOM"
	pass_insert "Business/a space/login" "$RANDOM"
	pass_insert "Business/a space/username" "$RANDOM"
	pass_insert "Business/euro/login" "$RANDOM"
	pass_insert "Business/euro/username" "$RANDOM"
	pass_insert "Email/donenfeld.com" "$RANDOM"
	pass_insert "Email/zx2c4.com" "$RANDOM"
	pass_insert "France/bank" "$RANDOM"
	pass_insert "France/freebox" "$RANDOM"
	pass_insert "France/mobilephone" "$RANDOM"
}

test_cleanup() {
	rm -rf "$TMP"
	mkdir -p "$TMP"
}

test_export() {
	export testname="$1"
	export PASSWORD_STORE_DIR="$TMP/${testname}-store"
	export PASSWORD_STORE_CLIP_TIME="1"
	export PATH="$TESTS_HOME:$PATH"
	export EDITOR="fake-editor"
	export GIT_DIR="$PASSWORD_STORE_DIR/.git"
	export GIT_WORK_TREE="$PASSWORD_STORE_DIR"
}

test_xclip() {
	echo "$RANDOM" | xclip -i &> /dev/null
	return $?
}


# Check for auxiliary programs
test_xclip && test_set_prereq XCLIP
