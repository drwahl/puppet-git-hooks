#!/bin/bash

# This script expects $1 to be passed and for $1 to be the filesystem location
# to a yaml file for which it will run syntax checks against.

syntax_errors=0
error_msg=$(mktemp /tmp/error_msg_yaml-syntax.XXXXX)

if [[ $2 ]]; then
    module_path="${1##*$2}"
else
    module_path=$1
fi

if [ -f $PWD/.yamllint ]
then
  YAMLLINT_CONFIG="-c $PWD/.yamllint"
elif [ -f ~/.yamllint ]
then
  YAMLLINT_CONFIG="-c $HOME/.yamllint"
fi

# Check YAML file syntax
$ERRORS_ONLY || echo -e "$(tput setaf 6)Checking yaml syntax for $module_path...$(tput sgr0)"
if type yamllint > /dev/null 2>&1; then
  yamllint $YAMLLINT_CONFIG -f parsable $1 &> "$error_msg"
else
  ruby -e "require 'yaml'; YAML.parse(File.open('$1'))" 2> "$error_msg" > /dev/null
fi
# prepare output
if [ $? -ne 0 ]; then
    sed -e "s/^/$(tput setaf 1)/" -e "s/$/$(tput sgr0)/" "$error_msg"
    syntax_errors=$((syntax_errors + 1))
    echo -e "$(tput setaf 1)Error: yaml syntax error in $module_path (see above)$(tput sgr0)"
fi
rm -f "$error_msg"

if [[ $syntax_errors -ne 0 ]]; then
    echo -e "$(tput setaf 1)Error: $syntax_errors syntax error(s) found in hiera yaml. Commit will be aborted.$(tput sgr0)"
    exit 1
fi

exit 0
