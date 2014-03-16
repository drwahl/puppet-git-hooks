#!/bin/sh
git_root=`git rev-parse --show-toplevel`
syntax_errors=0

# Get list of new/modified manifest and template files to check (in git index)
for puppetmodule in `git diff --cached --name-only --diff-filter=ACM | grep '\.*.erb$'`
do
    # Check ERB template syntax
    cat $git_root/$puppetmodule | erb -x -T - | ruby -c > /dev/null ;;
    if [ $? -ne 0 ]; then
        echo -n "$indexfile: "
        syntax_errors=`expr $syntax_errors + 1`
        echo "ERROR in $puppetmodule (see above)"
    fi
done

if [ "$syntax_errors" -ne 0 ]; then
    echo "Error: $syntax_errors syntax errors found in templates. Commit will be aborted."
    exit 1
fi

exit 0
