# pass-tomb completion file for bash

PASSWORD_STORE_EXTENSION_COMMANDS+=(update)

__password_store_extension_complete_update() {
	COMPREPLY+=($(compgen -W "-h --help -c --clip -n --no-symbols -l --length -p --provide -m --multiline -e --edit -f --force -V --version" -- ${cur}))
	_pass_complete_entries
}
