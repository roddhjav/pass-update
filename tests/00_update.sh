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
    _pass update --force Email/
    '

test_expect_success "Testing bulkd update" "
    _pass update --force Email/ &&
    _pass update --force 'Business/*/login'
    "

test_expect_success 'Updating password with specific length' '
    _pass update --force --length=50 France/bank
    '

test_expect_success 'Updating password with no symbols' '
    _pass update --force --no-symbols Business/site.eu
    '

if test_have_prereq XCLIP; then
    test_expect_success 'Updating password with clipboard output' '
        _pass update --force --clip Email/donenfeld.com
        '
fi

testing_password_notmatching() {
    echo -e "pass\ndummypass" | _pass update --force --provide Business/site.com
}
test_expect_success 'Updating password with a provided password' '
    echo -e "dummypass\ndummypass" | _pass update --force --provide Business/site.com &&
    test_must_fail testing_password_notmatching
    '

test_expect_success 'Updating a multiline password' '
    echo -e "dummypass\nlogin: dummylogin" | _pass update --force --multiline Business/site.eu
    '

test_expect_success 'Updating a password by editing it' '
    _pass update --edit Business/site.eu
    '

test_expect_success 'Testing corner cases' '
    test_must_fail _pass update --not-an-option &&
    test_must_fail _pass update --force --provide --clip Email/zx2c4.com &&
    test_must_fail _pass update --force --length number Email/zx2c4.com &&
    test_must_fail _pass update --force --provide --multiline Email/zx2c4.com &&
    _pass update --force Business/site1.com Business/site2.com Email/site3.com Socials/
    '

test_expect_success 'Testing help message' '
    _pass update --help | grep "pass update" &&
    _pass update --version | grep "A pass extension extension that provides an"
    '

test_done
