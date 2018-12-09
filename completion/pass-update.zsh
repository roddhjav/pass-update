#compdef pass-update
#description An easy flow for updating passwords

_pass-update () {
	_arguments : \
		{-h,--help}'[display help information]' \
		{-V,--version}'[display version information]' \
		{-c,--clip}'[write the password to the clipboard]' \
		{-n,--no-symbols}'[do not use any non-alphanumeric characters]' \
		{-l,--length}'[provide a password length]' \
		{-p,--provude}'[let the user specify a password by hand]' \
		{-m,--multiline}'[update a multiline password]' \
		{-e,--edit}'[edit the password using the default editor]' \
		{-f,--force}'[force update]'
	_pass_complete_entries_with_subdirs
}

_pass-update "$@"
