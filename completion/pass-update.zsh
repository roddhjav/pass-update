# pass-tomb completion file for zsh

PASSWORD_STORE_EXTENSION_SUBCOMMANDS+=(
	"update:An easy flow for updating passwords"
)

__password_store_extension_complete_update() {
	_arguments : \
		"-n[don't include symbols in password]" \
		"--no-symbols[don't include symbols in password]" \
		"-c[put it on the clipboard]" \
		"--clip[put it on the clipboard]" \
		"-l[provide a password length]" \
		"--length[provide a password length]" \
		"-m[update a multiline password]" \
		"--multiline[update multiline password]" \
		"-e[edit the password using the default editor]" \
		"--edit[edit the password using the default editor]" \
		"-f[overwrite existing path]" \
		"--force[overwrite existing path]" \
		"-V[show version information]" \
		"--version[show version information]" \
		"-h[print help message]" \
		"--help[print help message]"

	_pass_complete_entries_with_subdirs
}
