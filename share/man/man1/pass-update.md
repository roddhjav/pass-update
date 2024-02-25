% pass-update(1)
% pass update was written by Alexandre Pujol (alexandre@pujol.io)
% February 2024

# NAME

pass-update — A **pass**(1) extension that provides an easy flow for updating passwords.

# SYNOPSIS

**pass update** [*options…*] *pass-names...*

# DESCRIPTION

**pass update** extends the pass utility with an update command providing an easy flow for updating passwords. It supports path, directory and wildcard update. Moreover, you can select how to update your passwords by automatically
generating new passwords or manually setting your own.

**pass update** assumes that the first line of the password file is the password and so only ever updates the first line unless the `--multiline` option is specified.

By default, `pass update` prints the old password and wait for the user before generating a new one. This behaviour can be changed using the provided options.

# COMMAND

**pass update** [ `--clip`, `-c` ] [ `--no-symbols`, `-n` ] [ `--provide`, `-p` ] [`--length=<size>`, `-l <size>`] [ `--include=<regex>`, `-i <regex>` ] [ `--exclude=<regexp>`, `-e=<regexp>` ] [ `--edit`, `-E` ] [ `--multiline`, `-m` ] `pass-names...`

Update the password provided: print the password and wait for the user to generate a new one.

*pass-names*

: Can refer either to password store path(s) or directory. Both path and directory can be given in the same command. When updating a directory, all the passwords in this directory are updated. Wildcard update is supported by quoting `'*'`.


# OPTIONS

**`-c`, `--clip`**

:  Write both old and newly generated password to the clipboard.

**`-n`, `--no-symbols`**

: Do not use any non-alphanumeric characters in the generated password.

**`-l <size>`, `--length=<size>`**

: Provide a password length

**`-a`, `--auto-length`**

: The password length will match the previous password's length

**`-p`, `--provide`**

: Let the user specify a password by hand.

**`-m`, `--multiline`**

: Update a multiline password. Beware this option will overwrite the full password file instead of updating the password field.

**`-i <regexp>`, `--include=<regexp>`**

: Only update the passwords that match a regexp.

**`-e <regexp>`, `--exclude=<regexp>`**

: Do not update the passwords that match a given regexp.

**`-E`, `--edit`**

: Edit the password using the default editor. This editor can be specified with **EDITOR**.

**`-f`, `--force`**

: Do not wait for the user and generate a new password immediately.

**`-V`, `--version`**

: Show version information

**`-h`, `--help`**

: Show usage message.

# EXAMPLES

### Update Social/twitter.com

```sh
$ pass update Social/twitter.com
Changing password for Social/twitter.com
[}p&62"#"x'aF/_ix}6X3a)zq
Are you ready to generate a new password? [y/N] y
The generated password for Social/twitter.com is:
~*>afZsB+G\,c#+g$-,{OqJ{w
```


### Update all the Emails

```sh
$ pass update Email
Changing password for Email/donenfeld.com
b9b"k(u#m7|ST-400B5gM%[Kq
Are you ready to generate a new password? [y/N] y
The generated password for Email/donenfeld.com is:
m6~!b5U`OhloT~R,4-OCa:h$Q
Changing password for Email/zx2c4.com
4Fg{1Wg;WM{JZHqAMI:j5Jo$7
Are you ready to generate a new password? [y/N] y
The generated password for Email/zx2c4.com is:
@uLYW_X9a",?wDQN=hp/^Z!$J
```

### Set password length

```sh
$ pass update France/bank -l 50
Changing password for France/bank
9b'I;]b)>06xug!3.ME1*E+M3
login: zx2c4
Are you ready to generate a new password? [y/N] y
The generated password for France/bank is:
|3=&{ko:#I|A,P4*=[|hk^/V4jIcRN.uBBd-~RB0_L<sS[%k%-
```

### Provide a password by hand

```sh
$ pass update Business/site.com -p
Changing password for Business/site.com
Zk=u]HqjUAKPZ$gM_,LuZV8J2
login: zx2c4
Are you ready to provide a new password? [y/N] y
Enter the new password for Business/site.com:
Retype the new password for Business/site.com:
```

### Do not update PIN code

```
$ pass update --exclude '^[0-9]+$' /
```

### Update only PIN code

```sh
$ pass update --include '^[0-9]+$' /
```

# SEE ALSO
`pass(1)`, `pass-tomb(1)`, `pass-import(1)`, `pass-otp(1)`, `pass-audit(1)`
