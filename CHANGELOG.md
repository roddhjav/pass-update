# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog][keep-changelog].

## [2.2.1] - 2024-02-26

### Fixed

- Ensure that `share/__main__.py` is not part of the distribution packaging. [#31](https://github.com/roddhjav/pass-update/issues/31)

## [2.2] - 2024-02-26

### Added

- Add the `-a` option to generate password with the same lenght than the former ones.

### Changed

- The man pages are now generated from markdown with pandoc.
- Automated release process.
- Updated the sharness test suite to `1.2.0`

## [2.1] - 2018-12-11
### Added
* Add completion file for bash and zsh.
* Add an `--include` option to only update the password that match a regex. [#15](https://github.com/roddhjav/pass-update/issues/15)
* Add an `--exclude` option to not update the password that match a regex.
* Add ability to skip certain password modification. [#12](https://github.com/roddhjav/pass-import/issues/12)
* Added Gitlab CI and tests on Archlinux, CentOS, Debian, OpenSUSE, Ubuntu and Fedora.
* Added this changelog.

### Changed
* The `-e` option now means `--exclude` while `-E` means `--edit`.
* The test suite has been simplified and the tests extended.
* Multiple bash issues have been fixed.


## [2.0] - 2017-09-16
### Changed
* For this release, most of the source code has been completely re-implemented.
It allows us to provide the following **new** features in order to make password
update an easier flow.

### Added
* Support file, directory and wildcard update.
* Let the user specify a password by hand: `--provide`, `-p`
* Update a multi-line password: `--multiline`, `-m`
* Edit the password using the default editor: `--edit`, `-e`


## [1.0] - 2017-04-14
### Added
* Add `--no-symbols` option in order to not use any non-alphanumeric characters
  in the generated password.
* Add the ability to set the password length with the new `--length` option.


## [0.2] - 2017-03-01
### Fixed
* Fixed the makefile


## [0.1] - 2017-01-28

* Initial release.


[2.2.1]: https://github.com/roddhjav/pass-update/releases/tag/v2.2.1
[2.2]: https://github.com/roddhjav/pass-update/releases/tag/v2.2
[2.1]: https://github.com/roddhjav/pass-update/releases/tag/v2.1
[2.0]: https://github.com/roddhjav/pass-update/releases/tag/v2.0
[1.0]: https://github.com/roddhjav/pass-update/releases/tag/v1.0
[0.2]: https://github.com/roddhjav/pass-update/releases/tag/v0.2
[0.1]: https://github.com/roddhjav/pass-update/releases/tag/v0.1

[keep-changelog]: https://keepachangelog.com/en/1.0.0/
