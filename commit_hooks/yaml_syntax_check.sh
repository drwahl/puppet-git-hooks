#!/bin/sh
syntax_errors=0
error_msg=$(mktemp /tmp/error_msg_yaml-syntax.XXXXX)

# Get list of new/modified manifest and template files to check (in git index)
# Check YAML file syntax
ruby -e "require 'yaml'; YAML.parse(File.open('$1'))" 2> $error_msg > /dev/null
if [ $? -ne 0 ]; then
    cat $error_msg
    syntax_errors=`expr $syntax_errors + 1`
    echo "ERROR: yaml syntax error in $1 (see above)"
fi
rm -f $error_msg

if [ "$syntax_errors" -ne 0 ]; then
    echo "Error: $syntax_errors syntax error(s) found in hiera yaml. Commit will be aborted."
    exit 1
fi

exit 0
