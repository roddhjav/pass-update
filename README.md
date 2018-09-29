<h1 align="center">pass update</h1>
<p align="center">
    <a href="https://travis-ci.org/roddhjav/pass-update">
        <img src="https://img.shields.io/travis/roddhjav/pass-update/master.svg?style=flat-square"
             alt="Build Status" /></a>
    <a href="https://coveralls.io/github/roddhjav/pass-update">
        <img src="https://img.shields.io/coveralls/roddhjav/pass-update/master.svg?style=flat-square"
             alt="Code Coverage" /></a>
    <a href="https://www.codacy.com/app/roddhjav/pass-update">
        <img src="https://img.shields.io/codacy/grade/1eccb02d0b9a4c3d834c01b8f67b6cb4/master.svg?style=flat-square"
             alt="Code Quality" /></a>
    <a href="https://github.com/roddhjav/pass-update/releases/latest">
        <img src="https://img.shields.io/github/release/roddhjav/pass-update.svg?maxAge=600&style=flat-square"
             alt="Last Release" /></a>
</p>
<p align="center">
    A <a href="https://www.passwordstore.org/">pass</a> extension that provides
    an easy flow for updating passwords.
</p>

## Description
`pass update` extends the pass utility with an update command providing
an easy flow for updating passwords. It supports path, directory and wildcard
update. Moreover, you can select how to update your passwords by automatically
generating new passwords or manually setting your own.

`pass update` assumes that the first line of the password file is the password
and so only ever updates the first line unless the `--multiline` option is
specified.

By default, `pass update` prints the old password and waits for the user before
generating a new one. This behaviour can be changed using the provided options.

## Usage

```
pass update 2.0 - A pass extension that provides an
                  easy flow for updating passwords.

Usage:
        pass update [-h] [-n] [-l <s>] [-c | -p] [-p | -m] [-e] [-f] pass-names
            Provide an interactive solution to update a set of passwords.
            pass-names can refer either to password store path(s) or to directory.

            It prints the old password and waits for the user before generating
            a new one. This behaviour can be changed using the provided options.

            Only the first line of a password file is updated unless the
            --multiline opiton is specified.

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
```

See `man pass-update` for more information.

## Examples

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

**Requirements**
* `pass 1.7.0` or greater.

**From git**
```sh
git clone https://github.com/roddhjav/pass-update/
cd pass-update
sudo make install  # For OSX: make install PREFIX=/usr/local
```

**ArchLinux**

`pass-update` is available in the [Arch User Repository][aur].
```sh
pacaur -S pass-update  # or your preferred AUR install method
```

**Stable version**
```sh
wget https://github.com/roddhjav/pass-update/releases/download/v2.0/pass-update-2.0.tar.gz
tar xzf pass-update-2.0.tar.gz
cd pass-update-2.0
sudo make install  # For OSX: make install PREFIX=/usr/local
```

[Releases][releases] and commits are signed using [`06A26D531D56C42D66805049C5469996F0DF68EC`][keys].
You should check the key's fingerprint and verify the signature:
```sh
wget https://github.com/roddhjav/pass-update/releases/download/v2.0/pass-update-2.0.tar.gz.asc
gpg --recv-keys 06A26D531D56C42D66805049C5469996F0DF68EC
gpg --verify pass-update-2.0.tar.gz.sig
```

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

[keys]: https://pujol.io/keys
[aur]: https://aur.archlinux.org/packages/pass-update
[releases]: https://github.com/roddhjav/pass-update/releases
[keybase]: https://keybase.io/roddhjav
