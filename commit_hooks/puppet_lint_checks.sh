#!/bin/bash

# This script expects $1 to be passed and for $1 to be the filesystem location
# to a puppet manifest file for which it will run style guide checks against.

manifest_path="$1"
module_dir="$2"

syntax_errors=0
error_msg=$(mktemp /tmp/error_msg_puppet-lint.XXXXX)

if [ $module_dir ]; then
    manifest_name=$(echo $manifest_path | sed -e 's|'$module_dir'||')
else
    manifest_name="$manifest_path"
fi

# De-lint puppet manifests
echo -e "$(tput setaf 6)Checking puppet style guide compliance for $manifest_name...$(tput sgr0)"

# If a file named .puppet-lint.rc exists at the base of the repo then use it to
# enable or disable checks.
puppet_lint_cmd="puppet-lint --fail-on-warnings --with-filename"
puppet_lint_rcfile="${2}.puppet-lint.rc"
if [ -f $puppet_lint_rcfile ]; then
    echo -e "$(tput setaf 6)Applying custom config from .puppet-lint.rc$(tput sgr0)"
    puppet_lint_cmd="$puppet_lint_cmd --config $puppet_lint_rcfile"
else
    puppet_lint_cmd="$puppet_lint_cmd --no-80chars-check"
fi

$puppet_lint_cmd $1 2>&1 > $error_msg
RC=$?
if [ $RC -ne 0 ]; then
    syntax_errors=$(expr $syntax_errors + 1)
    cat $error_msg | sed -e 's|'$module_dir'||' -e "s/^/$(tput setaf 1)/" -e "s/$/$(tput sgr0)/"
    echo -e "$(tput setaf 1)Error: styleguide violation in $manifest_name (see above)$(tput sgr0)"
fi
rm -f $error_msg

if [ $syntax_errors -ne 0 ]; then
    echo -e "Error: $syntax_errors styleguide violation(s) found. Commit will be aborted.
Please follow the puppet style guide outlined at:
http://docs.puppetlabs.com/guides/style_guide.html" | sed -e "s/^/$(tput setaf 1)/" -e "s/$/$(tput sgr0)/"
    exit 1
fi

exit 0
