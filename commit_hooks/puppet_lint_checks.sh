#!/bin/sh

git_root=`git rev-parse --show-toplevel`

syntax_errors=0

# De-lint puppet manifests
if [ `which puppet-lint` ]; then
    for puppetmodule in `git diff --cached --name-only --diff-filter=ACM | grep \.*.pp$`; do
        puppet-lint --fail-on-warnings --with-filename --no-80chars-check --no-double_quoted_strings-check $git_root/$puppetmodule
        RC=$?
        if [ $RC -ne 0 ]; then
            exit $RC
        fi
    done
fi

exit 0
