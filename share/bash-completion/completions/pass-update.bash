# pass-update completion file for bash

PASSWORD_STORE_EXTENSION_COMMANDS+=(update)

__password_store_extension_complete_update() {
	local args=(-h --help -c --clip -n --no-symbols -l --length -p --provide
		-m --multiline -i --include -e --exclude -E --edit -f --force -V --version)
	COMPREPLY+=($(compgen -W "${args[*]}" -- ${cur}))
	_pass_complete_entries
}
