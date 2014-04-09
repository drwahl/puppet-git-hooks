#!/bin/sh
syntax_errors=0
error_msg=$(mktemp /tmp/error_msg_erb-syntax.XXXXX)

# Check ERB template syntax
cat $1 | erb -x -T - | ruby -c 2>&1 > $error_msg
if [ $? -ne 0 ]; then
    cat $error_msg
    syntax_errors=`expr $syntax_errors + 1`
    echo "ERROR: erb syntax error in $1 (see above)"
fi
rm $error_msg

if [ "$syntax_errors" -ne 0 ]; then
    echo "Error: $syntax_errors syntax errors found in templates. Commit will be aborted."
    exit 1
fi

exit 0
