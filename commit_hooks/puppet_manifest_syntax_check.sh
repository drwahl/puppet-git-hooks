#!/bin/bash

# This script expects $1 to be passed and for $1 to be the filesystem location
# to a puppet manifest file for which it will run syntax checks against.

manifest_path="$1"
module_dir="$2"

syntax_errors=0
error_msg=$(mktemp /tmp/error_msg_puppet-syntax.XXXXX)

if [ $module_dir ]; then
    manifest_name=$(echo $manifest_path | sed -e 's|'$module_dir'||')
    error_msg_filter="sed -e s|$module_dir||"
else
    manifest_name="$manifest_path"
    error_msg_filter="sed"
fi

# Get list of new/modified manifest and template files to check (in git index)
# Check puppet manifest syntax
echo -e "$(tput setaf 6)Checking puppet manifest syntax for $manifest_name...$(tput sgr0)"
puppet parser validate --color=false $1 > $error_msg 2>&1
if [ $? -ne 0 ]; then
    syntax_errors=`expr $syntax_errors + 1`
    cat $error_msg | $error_msg_filter -e "s/^/$(tput setaf 1)/" -e "s/$/$(tput sgr0)/"
    echo -e "$(tput setaf 1)Error: puppet syntax error in $manifest_name (see above)$(tput sgr0)"
fi
rm -f $error_msg

if [ "$syntax_errors" -ne 0 ]; then
    echo -e "$(tput setaf 1)Error: $syntax_errors syntax error(s) found in puppet manifests. Commit will be aborted.$(tput sgr0)"
    exit 1
fi

exit 0
