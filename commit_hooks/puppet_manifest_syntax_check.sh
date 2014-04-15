#!/bin/bash

# This script expects $1 to be passed and for $1 to be the filesystem location
# to a puppet manifest file for which it will run syntax checks against.

syntax_errors=0
error_msg=$(mktemp /tmp/error_msg_puppet-syntax.XXXXX)

# Get list of new/modified manifest and template files to check (in git index)
# Check puppet manifest syntax
echo -e "\e[0;36mChecking puppet manifest syntax for $1...\e[0m"
puppet parser validate --color=false $1 2>&1 > $error_msg
if [ $? -ne 0 ]; then
    echo -en "\e[0;31m"
    syntax_errors=`expr $syntax_errors + 1`
    cat $error_msg
    echo -e "Error: puppet syntax error in $1 (see above)\e[0m"
fi
rm -f $error_msg

if [ "$syntax_errors" -ne 0 ]; then
    echo -e "\e[0;31mError: $syntax_errors syntax error(s) found in puppet manifests. Commit will be aborted.\e[0m"
    exit 1
fi

exit 0
