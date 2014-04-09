#!/bin/sh
syntax_errors=0
error_msg=$(mktemp /tmp/error_msg_puppet-lint.XXXXX)

# De-lint puppet manifests
puppet-lint --fail-on-warnings --with-filename --no-80chars-check $1 2>&1 > $error_msg
RC=$?
if [ $RC -ne 0 ]; then
    syntax_errors=$(expr $syntax_errors + 1)
    cat $error_msg
    echo "Error: styleguide violation in $1 (see above)"
fi
rm -f $error_msg

if [ $syntax_errors -ne 0 ]; then
    echo "Error: $syntax_errors styleguide violation(s) found.  Commit will be aborted."
    exit 1
fi

exit 0
