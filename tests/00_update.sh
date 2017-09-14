#!/usr/bin/env bash
# shellcheck disable=SC2016,SC1091

export test_description="Testing pass update."

source ./setup

test_cleanup
test_export "update"
test_pass_populate &> /dev/null

test_expect_success 'Updating a password' '
    _pass update Business/site.com
    '

test_expect_success 'Updating multiple password' '
    _pass update --force France/bank France/freebox France/mobilephone &&
    '

test_expect_success 'Updating password with specific length' '
    _pass update --force --length=50 France/bank
    '

test_expect_success 'Updating password with no symbols' '
    _pass update --force --no-symbols Business/site.eu
    '

test_expect_success 'Testing help message' '
	_pass update --help
	'

test_done
