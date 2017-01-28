# pass update 

A [pass](https://www.passwordstore.org/) extension that provides a convenient
solution to update an existing password.

[![build status](https://gitlab.com/roddhjav/pass-update/badges/master/build.svg)](https://gitlab.com/roddhjav/pass-update/commits/master)

## Usage

```
Usage:
    pass update [--help,-h] [--clip,-c] [--force,-f] pass-names...
        Provide an interactive solution to update a set of passwords.
        It prints the old password and wait for the user before
        generating a new one. Both old and newly generated password
        can optionally be written on the clipboard using the --clip
        option. The --force option allows you to update the password
        immediately. Multiple pass-names can be given in order to
        update multiple password.

More information may be found in the pass-update(1) man page.
```

See `man pass-update` for more information.

## Example

Update `Social/facebook.com`

	pass update Social/facebook.com
	Changing password for Social/facebook.com
	[}p&62"#"x'aF/_ix}6X3a)zq
	Are you ready to generate a new password? [y/N] y
	The generated password for Social/facebook.com is:
	~*>afZsB+G\,c#+g$-,{OqJ{w

## Installation

**ArchLinux**

		pacaur -S pass-update

**Other linux**

		git clone https://gitlab.com/roddhjav/pass-update/
		cd pass-update
		sudo make install

**Requirments**

In order to use extension with `pass`, you need:
* `pass 1.7.0` or greater. As of today this version has not been released yet.
Therefore you need to install it by hand from zx2c4.com:

		git clone https://git.zx2c4.com/password-store
		cd password-store
		sudo make install

* You need to enable the extensions in pass: `PASSWORD_STORE_ENABLE_EXTENSIONS=true pass`.
You can create an alias in `.bashrc`: `alias pass='PASSWORD_STORE_ENABLE_EXTENSIONS=true pass'`


## Contribution
Feedback, contributors, pull requests are all very welcome.


## License

    Copyright (C) 2017  Alexandre PUJOL

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

