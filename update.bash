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

readonly VERSION="1.0"
cmd_update_version() {
	cat <<-_EOF
	$PROGRAM $COMMAND $VERSION - A pass extension that provides a convenient solution to update
                  existing passwords.
	_EOF
}

cmd_update_usage() {
	cmd_update_version
	echo
	cat <<-_EOF
	Usage:
        $PROGRAM update [options] pass-names...
            Provide an interactive solution to update a set of passwords.
            It prints the old password and wait for the user before
            generating a new one. Both old and newly generated password
            can optionally be written on the clipboard using the --clip
            option. The --force option allows you to update the password
            immediately. Specific password length can be given using --length
            and no symbols can be actived with --no-symbols. Multiple
            pass-names can be given in order to update multiple password.

    	Options:
            -c, --clip       Write the password in the clipboard.
            -n, --no-symbols Do not use any non-alphanumeric characters.
            -l, --length     Provide a password length.
            -f, --force      Force update.
            -h, --help	     Print this help message and exit.

	More information may be found in the pass-update(1) man page.
	_EOF
	exit 0
}

cmd_update() {
	[[ -z "${*}" ]] && die "Usage: $PROGRAM $COMMAND [-h] [-f] [--clip] [--no-symbols,-n] [--length <s>] pass-names..."

	local path
	for path in "$@"; do
		check_sneaky_paths "$path"
		printf "\e[1m\e[37mChanging password for \e[4m%s\e[0m\n" "$path"
		cmd_show "$path" "$CLIP" || exit 1
		[[ $FORCE = 1 ]] || yesno "Are you ready to generate a new password?"
		cmd_generate "$path" "$LENGTH" $SYMBOLS $CLIP "--in-place" || exit 1
	done
}

# Global options
FORCE=0
CLIP=""
SYMBOLS=""
LENGTH="$GENERATED_LENGTH"

# Getopt options
small_arg="cfnl:"
long_arg="clip,force,no-symbols,length:"
opts="$($GETOPT -o $small_arg -l $long_arg -n "$PROGRAM $COMMAND" -- "$@")"
err=$?
eval set -- "$opts"
while true; do case $1 in
	-c|--clip) CLIP="--clip"; shift ;;
	-f|--force) FORCE=1; shift ;;
	-n|--no-symbols) SYMBOLS="--no-symbols"; shift ;;
	-l|--length) LENGTH="$2"; shift 2 ;;
	--) shift; break ;;
esac done

[[ $err -ne 0 ]] && cmd_update_usage && exit 1
cmd_update "$@"
