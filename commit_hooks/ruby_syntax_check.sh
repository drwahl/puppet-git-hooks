#!/bin/bash

# This script expects $1 to be passed and for $1 to be the filesystem location
# to an RB file for which it will run syntax checks against. If $2 is passed,
# it will be stripped off of the path to provide prettier output, which is
# particularly useful for server-side hooks when tempdirs are created.

syntax_errors=0
error_msg=$(mktemp /tmp/error_msg_ruby-syntax.XXXXX)

if [ $2 ]; then
    module_path=$(echo $1 | sed -e 's|'$2'||')
else
    module_path=$1
fi

# Check ruby template syntax
echo -e "$(tput setaf 6)Checking ruby syntax for $module_path...$(tput sgr0)"
cat $1 | ruby -c > $error_msg 2>&1
if [ $? -ne 0 ]; then
    cat $error_msg | sed -e "s/^/$(tput setaf 1)/" -e "s/$/$(tput sgr0)/"
    syntax_errors=`expr $syntax_errors + 1`
    echo -e "$(tput setaf 1)Error: ruby syntax error in $module_path (see above)$(tput sgr0)"
fi
rm $error_msg

if [ "$syntax_errors" -ne 0 ]; then
    echo -e "$(tput setaf 1)Error: $syntax_errors syntax errors found in ruby files. Commit will be aborted.$(tput sgr0)"
    exit 1
fi

exit 0

