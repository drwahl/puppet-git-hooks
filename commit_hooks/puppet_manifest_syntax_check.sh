#!/bin/sh
syntax_errors=0
error_msg=$(mktemp /tmp/error_msg_puppet-syntax.XXXXX)

# Get list of new/modified manifest and template files to check (in git index)
# Check puppet manifest syntax
puppet parser validate --color=false $1 2>&1 > $error_msg
if [ $? -ne 0 ]; then
    syntax_errors=`expr $syntax_errors + 1`
    cat $error_msg
    echo "ERROR: puppet syntax error in $1 (see above)"
fi
rm -f $error_msg

if [ "$syntax_errors" -ne 0 ]; then
    echo "Error: $syntax_errors syntax error(s) found in puppet manifests. Commit will be aborted."
    exit 1
fi

exit 0
