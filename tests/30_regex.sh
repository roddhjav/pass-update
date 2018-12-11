#!/usr/bin/env bash
# shellcheck disable=SC2016,SC1091,SC2164

export test_description="Testing pass update."
cd tests
source ./commons


test_export "regex"
test_pass_populate &> /dev/null


test_expect_success 'Testing updating only passwords that follow a regex (1)' "
    _pass update --force --include '^[0-9]+$' Include/ &&
    test_password_is_not Include/numbers1 $PASSWORD_NUMBERS1 &&
    test_password_is_not Include/numbers2 $PASSWORD_NUMBERS2 &&
    test_password_is Include/letters $PASSWORD_LETTERS
    "

pass_insert Include/numbers1 "$PASSWORD_NUMBERS1"
pass_insert Include/numbers2 "$PASSWORD_NUMBERS2"
test_expect_success 'Testing updating only passwords that macth a regex (2)' "
    _pass update --force --include '^[a-z]+$' Include/ &&
    test_password_is Include/numbers1 $PASSWORD_NUMBERS1 &&
    test_password_is Include/numbers2 $PASSWORD_NUMBERS2 &&
    test_password_is_not Include/letters $PASSWORD_LETTERS
    "


test_expect_success 'Testing do not update passwords that macth a regex (1)' "
    _pass update --force --exclude '^[0-9]+$' Exclude/ &&
    test_password_is Exclude/numbers1 $PASSWORD_NUMBERS1 &&
    test_password_is Exclude/numbers2 $PASSWORD_NUMBERS2 &&
    test_password_is_not Exclude/letters $PASSWORD_LETTERS
    "

pass_insert Exclude/letters "$PASSWORD_LETTERS"
test_expect_success 'Testing do not update passwords that macth a regex (2)' "
    _pass update --force --exclude '^[a-z]+$' Exclude/ &&
    test_password_is_not Exclude/numbers1 $PASSWORD_NUMBERS1 &&
    test_password_is_not Exclude/numbers2 $PASSWORD_NUMBERS2 &&
    test_password_is Exclude/letters $PASSWORD_LETTERS
    "


test_done
