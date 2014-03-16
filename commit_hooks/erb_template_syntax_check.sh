#!/bin/sh
git_root=`git rev-parse --show-toplevel`
syntax_errors=0
error_msg=$(mktemp /tmp/error_msg_erb-syntax.XXXXX)

# Get list of new/modified manifest and template files to check (in git index)
for puppetmodule in `git diff --cached --name-only --diff-filter=ACM | grep '\.*.erb$'`
do
    # Check ERB template syntax
    cat $git_root/$puppetmodule | erb -x -T - | ruby -c > $error_msg
    if [ $? -ne 0 ]; then
        cat $error_msg
        syntax_errors=`expr $syntax_errors + 1`
        echo "ERROR in $puppetmodule (see above)"
    fi
done

rm $error_msg

if [ "$syntax_errors" -ne 0 ]; then
    echo "Error: $syntax_errors syntax errors found in templates. Commit will be aborted."
    exit 1
fi

exit 0
