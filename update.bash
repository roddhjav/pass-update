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

cmd_update_usage() {
	cat <<-_EOF
	Usage:
	    $PROGRAM update [--help,-h] [--clip,-c] [--force,-f] pass-names...
	        Provide an interactive solution to update a set of passwords.
	        It prints the old password and wait for the user before 
	        generating a new one. Both old and newly generated password
	        can optionally be written on the clipboard using the --clip
	        option. The --force option allows you to update the password
	        immediately. Multiple pass-names can be given in order to
	        update multiple password.
	        
	More information may be found in the pass-update(1) man page.	        
	_EOF
	exit 0
}

cmd_update() {
	local opts force=0 clip=""
	opts="$($GETOPT -o cf -l clip,force -n "$PROGRAM $COMMAND" -- "$@")"
	local err=$?
	eval set -- "$opts"
	while true; do case $1 in
		-c|--clip) clip="--clip"; shift ;;
		-f|--force) force=1; shift ;;
		--) shift; break ;;
	esac done
	
	[[ $err -ne 0 || -z "$@" ]] && die "Usage: $PROGRAM $COMMAND [--help,-h] [--clip,-c] [--force,-f] pass-names..."
	
	local path
	for path in "$@"; do 
		check_sneaky_paths "$path"
		printf "\e[1m\e[37mChanging password for \e[4m%s\e[0m\n" "$path"
		cmd_show "$path" "$clip" || exit 1
		[[ $force = 1 ]] || yesno "Are you ready to generate a new password?"
		cmd_generate "$path" "$clip" --in-place || exit 1
	done
}

[[ "$1" == "help" || "$1" == "--help" || "$1" == "-h" ]] && cmd_update_usage
cmd_update "$@"
