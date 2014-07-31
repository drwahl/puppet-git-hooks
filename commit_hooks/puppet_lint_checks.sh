#!/bin/bash

# This script expects $1 to be passed and for $1 to be the filesystem location
# to a puppet manifest file for which it will run style guide checks against.

syntax_errors=0
error_msg=$(mktemp /tmp/error_msg_puppet-lint.XXXXX)

if [ $2 ]; then
    module_path=$(echo $1 | sed -e 's|'$2'||')
else
    module_path=$1
fi

# De-lint puppet manifests
echo -e "\x1B[0;36mChecking puppet style guide compliance for $module_path...\x1B[0m"
puppet-lint --fail-on-warnings --with-filename --no-80chars-check $1 2>&1 > $error_msg
RC=$?
if [ $RC -ne 0 ]; then
    echo -en "\x1B[0;31m"
    syntax_errors=$(expr $syntax_errors + 1)
    cat $error_msg
    echo -e "Error: styleguide violation in $module_path (see above)\x1B[0m"
fi
rm -f $error_msg

if [ $syntax_errors -ne 0 ]; then
    echo -e "\x1B[0;31mError: $syntax_errors styleguide violation(s) found. Commit will be aborted.
Please follow the puppet style guide outlined at:
http://docs.puppetlabs.com/guides/style_guide.html\x1B[0m"
    exit 1
fi

exit 0
