#!/usr/bin/env bash
# shellcheck disable=SC2016,SC1091,SC2164

export test_description="Testing pass update."
cd tests
source ./commons


test_cleanup
test_export "paths"
test_pass_populate


test_expect_success 'Testing not updating one password' '
    _pass update Business/site.com &&
    test_password_is Business/site.com $PASSWORD
    '

test_expect_success 'Testing updating multiple passwords' '
    _pass update --force France/bank France/freebox France/mobilephone &&
    test_password_is_not France/bank $PASSWORD &&
    test_password_is_not France/freebox $PASSWORD &&
    test_password_is_not France/mobilephone $PASSWORD
    '

test_expect_success 'Testing updating folder' '
    _pass update --force Email/ &&
    test_password_is_not Email/donenfeld.com $PASSWORD &&
    test_password_is_not Email/zx2c4.com $PASSWORD
    '

test_expect_success "Testing bulk update" "
    _pass update --force 'Business/*/login' &&
    test_password_is_not Business/bitcoin/login $PASSWORD &&
    test_password_is_not 'Business/a space/login' $PASSWORD &&
    test_password_is_not Business/euro/login $PASSWORD
    "

test_expect_success "Testing updating everything" "
    _pass update --force / &> /dev/null
    "


test_done
