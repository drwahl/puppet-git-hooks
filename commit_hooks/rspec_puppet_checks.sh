#!/bin/sh

git_root=`git rev-parse --show-toplevel`

syntax_errors=0

# Run rspec-puppet tests
if [ `which rspec` ]; then
    for puppetmodule in `git diff --cached --name-only --diff-filter=ACM | grep '\.*.pp$\|\.*.rb$'`; do
        module_dir=$(dirname $puppetmodule | cut -d"/" -f1,2)
        cd $module_dir
        rspec > /dev/null
        RC=$?
        cd - > /dev/null
        if [ $RC -ne 0 ]; then
            cd $module_dir
            rspec --color --format d
            echo "rspec-puppet test failed for $module_dir (see above)"
            cd - > /dev/null
            syntax_errors=`expr $syntax_errors + 1`
        fi
    done
fi

if [ "$syntax_errors" -ne 0 ]; then
    echo "Error: $syntax_errors rspec-puppet tests failed, aborting commit."
    exit 1
fi

exit 0
