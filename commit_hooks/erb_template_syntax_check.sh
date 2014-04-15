#!/bin/bash

# This script expects $1 to be passed and for $1 to be the filesystem location
# to an ERB file for which it will run syntax checks against.

syntax_errors=0
error_msg=$(mktemp /tmp/error_msg_erb-syntax.XXXXX)

# Check ERB template syntax
echo -e "\e[0;36mChecking erb template syntax for $1...\e[0m"
cat $1 | erb -x -T - | ruby -c 2>&1 > $error_msg
if [ $? -ne 0 ]; then
    echo -en "\e[0;31m"
    cat $error_msg
    syntax_errors=`expr $syntax_errors + 1`
    echo -e "Error: erb syntax error in $1 (see above)\e[0m"
fi
rm $error_msg

if [ "$syntax_errors" -ne 0 ]; then
    echo -e "\e[0;31mError: $syntax_errors syntax errors found in templates. Commit will be aborted.\e[0m"
    exit 1
fi

exit 0
