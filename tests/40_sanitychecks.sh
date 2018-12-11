#!/usr/bin/env bash
# shellcheck disable=SC2016,SC1091,SC2164

export test_description="Testing pass update."
cd tests
source ./commons


test_export "sanitychecks"


test_expect_success 'Testing corner cases' '
    test_must_fail _pass update --not-an-option &&
    _pass update warning-not-in-the-store/
    '

test_expect_success 'Testing incompatible options: --provide & --clip' '
    test_must_fail _pass update --force --provide --clip Email/zx2c4.com
    '

test_expect_success 'Testing incompatible options: --provide & --multiline' '
    test_must_fail _pass update --force --provide --multiline Email/zx2c4.com
    '

test_expect_success 'Testing wrong password length' '
    test_must_fail _pass update --force --length number Email/zx2c4.com
    '

test_expect_success 'Testing help message' '
    _pass update --help
    '

test_expect_success 'Testing version message' '
    _pass update --version
    '


test_done
