#!/bin/bash

# $1 is the puppet-lint mode (enabled, permissive, disabled)
# This script expects $2 to be passed and for $2 to be the filesystem location
# to a puppet manifest file for which it will run style guide checks against.

CHECK_PUPPET_LINT="$1"
manifest_path="$2"
module_dir="$3"

syntax_errors=0
error_msg=$(mktemp /tmp/error_msg_puppet-lint.XXXXX)

if [ $module_dir ]; then
    manifest_name=$(echo $manifest_path | sed -e 's|'$module_dir'||')
    error_msg_filter="sed -e s|$module_dir||"
else
    manifest_name="$manifest_path"
    error_msg_filter="sed"
fi

# De-lint puppet manifests
echo -e "$(tput setaf 6)Checking puppet style guide compliance for $manifest_name...$(tput sgr0)"

# If a file named .puppet-lint.rc exists at the base of the repo then use it to
# enable or disable checks.
puppet_lint_cmd="puppet-lint --fail-on-warnings --with-filename"
puppet_lint_rcfile="${3}.puppet-lint.rc"
if [ -f $puppet_lint_rcfile ]; then
    echo -e "$(tput setaf 6)Applying custom config from .puppet-lint.rc$(tput sgr0)"
    puppet_lint_cmd="$puppet_lint_cmd --config $puppet_lint_rcfile"
else
    puppet_lint_cmd="$puppet_lint_cmd --no-80chars-check"
fi

$puppet_lint_cmd $2 2>&1 > $error_msg
RC=$?
if [ $RC -ne 0 ]; then
    syntax_errors=$(expr $syntax_errors + 1)
    cat $error_msg | $error_msg_filter -e "s/^/$(tput setaf 1)/" -e "s/$/$(tput sgr0)/"
    echo -e "$(tput setaf 1)Error: styleguide violation in $manifest_name (see above)$(tput sgr0)"
fi
rm -f $error_msg

if [ $syntax_errors -ne 0 ]; then
    if [ "$CHECK_PUPPET_LINT" = "permissive" ] ; then
        echo -e "$(tput setaf 6)Puppet-lint run in permissive mode. Commit won't be aborted$(tput sgr0)"
    else
        echo -e "Error: $syntax_errors styleguide violation(s) found. Commit will be aborted.
Please follow the puppet style guide outlined at:
http://docs.puppetlabs.com/guides/style_guide.html" | sed -e "s/^/$(tput setaf 1)/" -e "s/$/$(tput sgr0)/"
    exit 1
    fi
fi

exit 0
