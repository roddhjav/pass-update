#!/usr/bin/env bash
# shellcheck disable=SC2016,SC1091,SC2164

export test_description="Testing pass update."
cd tests
source ./commons


test_export "options"
test_pass_populate


test_expect_success 'Testing updating password with specific length' '
    _pass update --force --length=50 France/bank &&
    newpasswd="$(pass show France/bank | head -n 1)" &&
    [[ "${#newpasswd}" == 50 ]]
    '

test_expect_success 'Testing updating password with no symbols' '
    _pass update --force --no-symbols Business/site.eu
    '

test_expect_success 'Testing updating password with a provided password' '
    echo -e "dummypass\ndummypass" | _pass update --force --provide Business/site.com &&
    test_password_is Business/site.com dummypass
    '

testing_password_notmatching() {
    echo -e "pass\ndummypass" | _pass update --force --provide Business/site.com
}
test_expect_success 'Testing passwords not matching' '
    test_must_fail testing_password_notmatching
        '

test_expect_success 'Testing updating a multiline password' '
    echo -e "dummypass\nlogin: dummylogin" | _pass update --force --multiline Business/site.eu &&
    test_password_is Business/site.eu dummypass
    '

test_expect_success 'Testing updating a password by editing it' "
    _pass update --edit Business/site.eu &&
    test_password_is Business/site.eu 'correct horse battery staple'
    "

if test_have_prereq XCLIP; then
    test_expect_success 'Testing updating password with clipboard output' '
        _pass update --force --clip Email/donenfeld.com &&
        test_password_is_not Email/donenfeld.com $PASSWORD
        '
fi


test_done
