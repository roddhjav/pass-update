# pass update - Password Store Extension (https://www.passwordstore.org/)
# Copyright (C) 2018-2024 Alexandre PUJOL <alexandre@pujol.io>.
# SPDX-License-Identifier: GPL-3.0-or-later
"""Generate release in this repo."""

import re
import subprocess  # nosec
import sys
from datetime import datetime

TITLE = 'pass-update'


def git_add(path: str):
    """Add file contents to the index."""
    subprocess.call(["/usr/bin/git", "add", path], shell=False)  # nosec


def git_commit(msg: str):
    """Record changes to the repository."""
    subprocess.call(["/usr/bin/git", "commit", "-S", "-m", msg],
                    shell=False)  # nosec


def debian_changelog(version: str):
    """Update debian/changelog."""
    path = "debian/changelog"
    now = datetime.now()
    date = now.strftime('%a, %d %b %Y %H:%M:%S +0000')
    template = f"""{TITLE} ({version}-1) stable; urgency=medium

  * Release {TITLE} v{version}

 -- Alexandre Pujol <alexandre@pujol.io>  {date}

"""
    with open(path, 'r') as file:
        data = file.read()
    with open(path, 'w') as file:
        file.write(template + data)
    git_add(path)


def makerelease():
    """Make a new release commit."""
    version = sys.argv.pop()
    oldversion = sys.argv.pop()
    release = {
        'README.md': [
            (f'pass-update-{oldversion}', f'pass-update-{version}'),
            (f'pass update {oldversion}', f'pass update {version}'),
            (f'v{oldversion}', f'v{version}'),
        ],
        'update.bash': [
            (f'VERSION="{oldversion}"', f'VERSION="{version}"'),
        ],
    }
    debian_changelog(version)
    for path, pattern in release.items():
        with open(path, 'r') as file:
            data = file.read()

        for old, new in pattern:
            data = re.sub(old, new, data)

        with open(path, 'w') as file:
            file.write(data)

        git_add(path)
    git_commit(f"Release {TITLE} {version}")


if __name__ == "__main__":
    if '--release' in sys.argv:
        makerelease()
    else:
        print('Usage: python share --release OLDVERSION VERSION')
        sys.exit(1)
