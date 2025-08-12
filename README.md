[<img src="https://gitlab.com/uploads/-/system/project/avatar/2394420/logo.png" align="right" height="110"/>][github-link]

# pass update

[![][gitlab]][gitlab-link] [![][coverage]][coverage-link] [![][quality]][quality-link] [![][release]][release-link]

**A [pass] extension that provides an easy flow for updating passwords.**


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
pass update 2.2.1 - A pass extension that provides an easy flow for updating passwords.

Usage:
    pass update [-h] [-n] [-l <s>] [-c | -p] [-p | -m]
                [-e <r>] [-i <r>] [-E] [-f] pass-names...
         Provide an interactive solution to update a set of passwords.
         pass-names can refer either to password store path(s) or to
         directory.

         It prints the old password and waits for the user before generating
         a new one. This behaviour can be changed using the provided options.

         Only the first line of a password file is updated unless the
         --multiline option is specified.

     Options:
         -c, --clip        Write the password to the clipboard.
         -n, --no-symbols  Do not use any non-alphanumeric characters.
         -l, --length <s>  Provide a password length.
         -a, --auto-length Match the previous password's length.
         -p, --provide     Let the user specify a password by hand.
         -m, --multiline   Update a multiline password.
         -i, --include <r> Only update the passwords that match a regex.
         -e, --exclude <r> Do not update the passwords that macth a regex.
         -E, --edit        Edit the password using the default editor.
         -f, --force       Force update.
         -V, --version     Show version information.
         -h, --help        Print this help message and exit.

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
pass update -l 50 France/bank
Changing password for France/bank
9b'I;]b)>06xug!3.ME1*E+M3
login: zx2c4
Are you ready to generate a new password? [y/N] y
The generated password for France/bank is:
|3=&{ko:#I|A,P4*=[|hk^/V4jIcRN.uBBd-~RB0_L<sS[%k%-
```

**Provide a password by hand**
```
pass update -p Business/site.com
Changing password for Business/site.com
Zk=u]HqjUAKPZ$gM_,LuZV8J2
login: zx2c4
Are you ready to provide a new password? [y/N] y
Enter the new password for Business/site.com:
Retype the new password for Business/site.com:
```

**Do not update PIN code**
```
pass update --exclude '^[0-9]+$' /
```

**Update only PIN code**
```
pass update --include '^[0-9]+$' /
```

## Installation [<img src="https://repology.org/badge/vertical-allrepos/pass-update.svg" align="right">][repology-link]

**Requirements**
* `pass 1.7.0` or greater.

**ArchLinux**

`pass-update` is available in the [Arch User Repository][aur].
```sh
yay -S pass-update  # or your preferred AUR install method
```

**Debian/Ubuntu**

`pass-update` is available [my own debian repository][repo] with the package name
`pass-extension-update`. Both the repository and the package are signed with
my GPG key: [`06A26D531D56C42D66805049C5469996F0DF68EC`][keys].
```sh
wget -qO - https://pkg.pujol.io/debian/gpgkey | gpg --dearmor | sudo tee /usr/share/keyrings/pujol.io.gpg >/dev/null
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/pujol.io.gpg] https://pkg.pujol.io/debian/repo all main' | sudo tee /etc/apt/sources.list.d/pkg.pujol.io.list
sudo apt-get update
sudo apt-get install pass-extension-update
```

**NixOS**
```sh
nix-env -iA nixos.passExtensions.pass-update
```

**OSX**

`pass-update` is available with Homebrew using a [third-party][brew-tap] repository
```sh
brew tap simplydanny/pass-extensions
brew install pass-update
```

**From git**
```sh
git clone https://github.com/roddhjav/pass-update/
cd pass-update
sudo make install  # For OSX: make install PREFIX=$(brew --prefix)
```

**Stable version**
```sh
wget https://github.com/roddhjav/pass-update/releases/download/v2.2.1/pass-update-2.2.1.tar.gz
tar xzf pass-update-2.2.1.tar.gz
cd pass-update-2.2.1
sudo make install  # For OSX: make install PREFIX=$(brew --prefix)
```

[Releases][releases] and commits are signed using [`06A26D531D56C42D66805049C5469996F0DF68EC`][keys].
You should check the key's fingerprint and verify the signature:
```sh
wget https://github.com/roddhjav/pass-update/releases/download/v2.2.1/pass-update-2.2.1.tar.gz.asc
gpg --recv-keys 06A26D531D56C42D66805049C5469996F0DF68EC
gpg --verify pass-update-2.2.1.tar.gz.sig
```

## Contribution

Feedback, contributors, pull requests are all very welcome.

[github-link]: https://github.com/roddhjav/pass-update
[gitlab]: https://gitlab.com/roddhjav/pass-update/badges/master/pipeline.svg?style=flat-square
[gitlab-link]: https://gitlab.com/roddhjav/pass-update/pipelines
[coverage]: https://img.shields.io/coveralls/roddhjav/pass-update/master.svg?style=flat-square
[coverage-link]: https://coveralls.io/github/roddhjav/pass-update
[quality]: https://img.shields.io/codacy/grade/1eccb02d0b9a4c3d834c01b8f67b6cb4/master.svg?style=flat-square
[quality-link]: https://www.codacy.com/app/roddhjav/pass-update
[release]: https://img.shields.io/github/release/roddhjav/pass-update.svg?maxAge=600&style=flat-square
[release-link]: https://github.com/roddhjav/pass-update/releases/latest
[repology-link]: https://repology.org/project/pass-update/versions

[pass]: https://www.passwordstore.org/
[keys]: https://pujol.io/keys
[repo]: https://pkg.pujol.io
[aur]: https://aur.archlinux.org/packages/pass-update
[releases]: https://github.com/roddhjav/pass-update/releases
[keybase]: https://keybase.io/roddhjav
[brew-tap]: https://github.com/SimplyDanny/homebrew-pass-extensions
