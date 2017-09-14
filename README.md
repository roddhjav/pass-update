# pass update [![build][build-img]][build-url] [![coverage][cover-img]][cover-url] [![climate][clima-img]][clima-url]

A [pass][pass] extension that provides an easy flow for updating passwords.

## Description
`pass update` extends the pass utility with an update command providing
an easy flow for updating passwords. It allows you to update all the passwords
in a folder or to provide the extact list of password to update. Moreover, you
can select how to update your passwords by automaticaly generating new passwords
or manually setting your own.

By default `pass update` prints the old password and wait for the user before
generating a new one. This behavior can be changed using the provided options.

## Usage

```
pass update 2.0 - A pass extension extension that provides an
                  easy flow for updating passwords.

Usage:
        pass update [-h] [-n] [-l <s>] [-c | -p] [-p | -m] [-f] pass-names...
            Provide an interactive solution to update a set of passwords.
            pass-names can refer either to password store path(s) or to directory.

            It prints the old password and wait for the user before generating
            a new one. This behavior can be changed using the provided options.

    	Options:
            -c, --clip       Write the password in the clipboard.
            -n, --no-symbols Do not use any non-alphanumeric characters.
            -l, --length     Provide a password length.
            -p, --provide    Let the user specify a password by hand.
            -m, --multiline  Update a multiline password.
            -f, --force      Force update.
            -V, --version    Show version information.
            -h, --help       Print this help message and exit.

More information may be found in the pass-update(1) man page.
```

See `man pass-update` for more information.

## Example

**Update `Social/twitter.com`**
```
pass update Social/twitter.com
Changing password for Social/twitter.com
[}p&62"#"x'aF/_ix}6X3a)zq
Are you ready to generate a new password? [y/N] y
The generated password for Social/twitter.com is:
~*>afZsB+G\,c#+g$-,{OqJ{w
```

**Update all the Emails**
```
pass update Email
Changing password for Email/donenfeld.com
b9b"k(u#m7|ST-400B5gM%[Kq
Are you ready to generate a new password? [y/N] y
The generated password for Email/donenfeld.com is:
m6~!b5U`OhloT~R,4-OCa:h$Q
Changing password for Email/zx2c4.com
HWl7u\Aqdk]AY$y!='@>]8"@`
Are you ready to generate a new password? [y/N] y
The generated password for Email/zx2c4.com is:
@uLYW_X9a",?wDQN=hp/^Z!$J
```

**Set password length**
```
pass update France/bank -l 50
Changing password for France/bank
9b'I;]b)>06xug!3.ME1*E+M3
login: zx2c4
Are you ready to generate a new password? [y/N] y
The generated password for France/bank is:
|3=&{ko:#I|A,P4*=[|hk^/V4jIcRN.uBBd-~RB0_L<sS[%k%-
```

**Provide a password by hand**
```
pass update Business/site.com -p
Changing password for Business/site.com
Zk=u]HqjUAKPZ$gM_,LuZV8J2
login: zx2c4
Are you ready to provide a new password? [y/N] y
Enter the new password for Business/site.com:
Retype the new password for Business/site.com:
```

## Installation

**From git**
```sh
git clone https://github.com/roddhjav/pass-update/
cd pass-update
sudo make install
```

**Generic Linux**
```sh
wget https://github.com/roddhjav/pass-update/archive/v2.0.tar.gz
tar xzf v2.0.tar.gz
cd pass-update-2.0
sudo make install
```

**ArchLinux**

`pass-update` is available in the [Arch User Repository][aur].
```sh
pacaur -S pass-update
```

**Requirements**
* `pass 1.7.0` or greater.
* If you do not want to install this extension as system extension, you need to
enable user extension with `PASSWORD_STORE_ENABLE_EXTENSIONS=true pass`. You can
create an alias in `.bashrc`: `alias pass='PASSWORD_STORE_ENABLE_EXTENSIONS=true pass'`

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

[build-img]: https://travis-ci.org/roddhjav/pass-update.svg?branch=master
[build-url]: https://travis-ci.org/roddhjav/pass-update
[cover-img]: https://coveralls.io/repos/github/roddhjav/pass-update/badge.svg?branch=master
[cover-url]: https://coveralls.io/github/roddhjav/pass-update?branch=master
[clima-img]: https://codeclimate.com/github/roddhjav/pass-update/badges/gpa.svg
[clima-url]: https://codeclimate.com/github/roddhjav/pass-update

[pass]: https://www.passwordstore.org/
[aur]: https://aur.archlinux.org/packages/pass-update
