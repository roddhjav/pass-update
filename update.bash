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

# shellcheck disable=SC2086,SC2015

readonly VERSION="2.0"

warning() { echo -e "Warning: ${*}" >&2; }

cmd_update_version() {
	cat <<-_EOF
	$PROGRAM $COMMAND $VERSION - A pass extension that provides an
                  easy flow for updating passwords.
	_EOF
}

cmd_update_usage() {
	cmd_update_version
	echo
	cat <<-_EOF
	Usage:
        $PROGRAM update [-h] [-n] [-l <s>] [-c | -p] [-p | -m] [-e] [-f] pass-names
            Provide an interactive solution to update a set of passwords.
            pass-names can refer either to password store path(s) or to
            directory.

            It prints the old password and waits for the user before generating
            a new one. This behaviour can be changed using the provided options.

    	Options:
            -c, --clip       Write the password to the clipboard.
            -n, --no-symbols Do not use any non-alphanumeric characters.
            -l, --length     Provide a password length.
            -p, --provide    Let the user specify a password by hand.
            -m, --multiline  Update a multiline password.
            -e, --edit       Edit the password using the default editor.
            -f, --force      Force update.
            -V, --version    Show version information.
            -h, --help       Print this help message and exit.

	More information may be found in the pass-update(1) man page.
	_EOF
}

# Print the content of a passfile
# $1: Path in the password store
_show() {
	local path="${1%/}" passfile="$PREFIX/$path.gpg"
	[[ -f $passfile ]] && { $GPG -d "${GPG_OPTS[@]}" "$passfile" || exit $?; }
}

# Insert data to the password store
# $1: Path in the password store
# $2: Data to insert
_insert() {
	local path="${1%/}" data="$2" passfile="$PREFIX/$path.gpg"

	set_git "$passfile"
	mkdir -p -v "$PREFIX/$(dirname "$path")"
	set_gpg_recipients "$(dirname "$path")"
	if [[ $MULTLINE -eq 0 ]]; then
		$GPG -e "${GPG_RECIPIENT_ARGS[@]}" -o "$passfile" "${GPG_OPTS[@]}" <<<"$data" || \
			die "Error: Password encryption aborted."
	else
		echo -e "Enter the updated contents of $path and press Ctrl+D when finished:\n"
		$GPG -e "${GPG_RECIPIENT_ARGS[@]}" -o "$passfile" "${GPG_OPTS[@]}" || \
			die "Error: Password encryption aborted."
	fi
	git_add_file "$passfile" "Update password for $path to store."
}

cmd_update() {
	# Sanity checks
	[[ -z "${*}" ]] && die "Usage: $PROGRAM $COMMAND [-h] [-n] [-l <s>] [-c | -p] [-p | -m] [-e] [-f] pass-names"
	[[ ! $LENGTH =~ ^[0-9]+$ ]] && die "Error: pass-length \"$LENGTH\" must be a number."
	[[ ! -z "$CLIP" && $PROVIDED -eq 1 ]] && die "Error: cannot use the options --clip and --provide together"
	[[ $MULTLINE -eq 1 && $PROVIDED -eq 1 ]] && die "Error: cannot use the options --multiline and --provide together"

	# Get a curated list of path to update
	typeset -a paths=() passfiles=()
	local path passfile passdir file tmpfile
	for path in "$@"; do
		check_sneaky_paths "$path"
		passfile="$PREFIX/${path%/}.gpg"
		passdir="$PREFIX/${path%/}"
		if [[ $path =~ [*] ]]; then
			for file in $PREFIX/$path.gpg; do
				if [[ -f $file ]]; then
					tmpfile="${file#$PREFIX/}"
					paths+=("${tmpfile%.gpg}")
				fi
			done
		elif [[ -d "$passdir" ]]; then
			passfiles=($(find "$passdir" -type f -iname '*.gpg' -printf "$path/%P\n"))
			for file in "${passfiles[@]}"; do paths+=("${file%.gpg}") ; done
		else
			[[ -f $passfile ]] && paths+=("$path") || warning "$path is not in the password store."
		fi
	done

	local content
	for path in "${paths[@]}"; do
		if [[ $EDIT -eq 0 ]]; then
			# Show old password
			printf "\e[1m\e[37mChanging password for \e[4m%s\e[0m\n" "$path"
			content="$(_show "$path")"
			if [[ -z "$CLIP" ]]; then
				printf "%s\n" "$content"
			else
				clip "$(echo "$content" | tail -n +1 | head -n 1)" "$path"
			fi

			# Ask user for confirmation
			if [[ $YES -eq 0 ]]; then
				[[ $PROVIDED -eq 1 || $MULTLINE -eq 1 ]] && verb="provide" || verb="generate"
				read -r -p "Are you ready to $verb a new password? [y/N] " response
                [[ $response == [yY] ]] || continue
			fi

			# Update the password
			if [[ $PROVIDED -eq 1 ]]; then
				local password password_again
				while true; do
					read -r -p "Enter the new password for $path: " -s password || exit 1
					echo
					read -r -p "Retype the new password for $path: " -s password_again || exit 1
					echo
					if [[ "$password" == "$password_again" ]]; then
						break
					else
						die "Error: the entered passwords do not match."
					fi
				done
				_insert "$path" "$(echo "$content" | sed $'1c \\\n'"$(sed 's/[\/&]/\\&/g' <<<"$password")"$'\n')"
			elif [[ $MULTLINE -eq 1 ]]; then
				_insert "$path"
			else
				cmd_generate "$path" "$LENGTH" $SYMBOLS $CLIP "--in-place" || exit 1
			fi
		else
			cmd_edit "$path"
		fi
	done
}

# Global options
YES=0
MULTLINE=0
CLIP=""
SYMBOLS=""
PROVIDED=0
EDIT=0
LENGTH="$GENERATED_LENGTH"

# Getopt options
small_arg="hVcfnl:pme"
long_arg="help,version,clip,force,no-symbols,length:,provide,multiline,edit"
opts="$($GETOPT -o $small_arg -l $long_arg -n "$PROGRAM $COMMAND" -- "$@")"
err=$?
eval set -- "$opts"
while true; do case $1 in
	-c|--clip) CLIP="--clip"; shift ;;
	-f|--force) YES=1; shift ;;
	-n|--no-symbols) SYMBOLS="--no-symbols"; shift ;;
	-p|--provide) PROVIDED=1; shift ;;
	-l|--length) LENGTH="$2"; shift 2 ;;
	-m|--multiline) MULTLINE=1; shift ;;
	-e|--edit) EDIT=1; shift ;;
	-h|--help) shift; cmd_update_usage; exit 0 ;;
	-V|--version) shift; cmd_update_version; exit 0 ;;
	--) shift; break ;;
esac done

[[ $err -ne 0 ]] && cmd_update_usage && exit 1
cmd_update "$@"
