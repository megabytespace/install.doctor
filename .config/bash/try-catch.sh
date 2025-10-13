#!/usr/bin/env bash

# Try / catch in bash
#
# ````
# #!/bin/bash
# export AnException=100
# export AnotherException=101
#
# # start with a try
# try
# (   # open a subshell !!!
#     echo "do something"
#     [ someErrorCondition ] && throw $AnException
#
#     echo "do something more"
#     executeCommandThatMightFail || throw $AnotherException
#
#     throwErrors # automaticatly end the try block, if command-result is non-null
#     echo "now on to something completely different"
#     executeCommandThatMightFail
#
#     echo "it's a wonder we came so far"
#     executeCommandThatFailsForSure || true # ignore a single failing command
#
#     ignoreErrors # ignore failures of commands until further notice
#     executeCommand1ThatFailsForSure
#     local result = $(executeCommand2ThatFailsForSure)
#     [ result != "expected error" ] && throw $AnException # ok, if it's not an expected error, we want to bail out!
#     executeCommand3ThatFailsForSure
#
#     # make sure to clear $ex_code, otherwise catch * will run
#     # echo "finished" does the trick for this example
#     echo "finished"
# )
# # directly after closing the subshell you need to connect a group to the catch using ||
# catch || {
#     # now you can handle
#     case $ex_code in
#         $AnException)
#             echo "AnException was thrown"
#         ;;
#         $AnotherException)
#             echo "AnotherException was thrown"
#         ;;
#         *)
#             echo "An unexpected exception was thrown"
#             throw $ex_code # you can rethrow the "exception" causing the script to exit if not caught
#         ;;
#     esac
# }
# ```
# Source: https://stackoverflow.com/a/25180186`

# shellcheck disable=SC2034
Logger="${BASH_SOURCE[0]}../log"

# @description Turn on fail on errors mode
function try() {
    [[ $- = *e* ]]; SAVED_OPT_E=$?
    set +e
}

# @description Turn on fail on errors mode
function throw() {
    exit "$1"
}

# @description Turn on fail on errors mode
function catch() {
    export ex_code=$?
    # shellcheck disable=SC2004
    (( $SAVED_OPT_E )) && set +e
    return $ex_code
}

# @description Turn on fail on errors mode
function throwErrors() {
    set -e
}

# @description Do not fail on errors mode
function ignoreErrors() {
    set +e
}
