#!/bin/bash

# This script expects $1 to be passed and for $1 to be the filesystem location
# to a puppet manifest file for which it will run syntax checks against.

CHECK_PUPPET_DOCS="$1"
manifest_path="$2"
module_dir="$3"
USE_PUPPET_FUTURE_PARSER="$4"

documentations_errors=0
error_msg=$(mktemp /tmp/error_msg_puppet-syntax.XXXXX)

if [[ $module_dir ]]; then
    manifest_name="${manifest_path##*$module_dir}"
    error_msg_filter="sed -e s|$module_dir||"
else
    manifest_name="$manifest_path"
    error_msg_filter="sed"
fi

# Get list of new/modified manifest and template files to check (in git index)
# Check puppet manifest syntax
$ERRORS_ONLY || echo -e "$(tput setaf 6)Checking puppet documentation for $manifest_name...$(tput sgr0)"
if [[ $USE_PUPPET_FUTURE_PARSER != "enabled" ]]; then
    puppet strings --color=false "$1" | grep -Eo -e '^\[warn\]:.*$' > "$error_msg"
else
    puppet strings --parser future --color=false "$1" | grep -Eo -e '^\[warn\]:.*$' > "$error_msg"
fi

if [[ $? -ne 1 ]]; then
  documentations_errors=$((documentations_errors + 1))
    $error_msg_filter -e "s/^/$(tput setaf 1)/" -e "s/$/$(tput sgr0)/" < "$error_msg"
    echo -e "$(tput setaf 1)Error: faulty puppet documentation in $manifest_name (see above)$(tput sgr0)"
fi
rm -f "$error_msg"

if [[ $documentations_errors -ne 0 ]]; then
  if [[ $CHECK_PUPPET_DOCS == "permissive" ]] ; then
    echo -e "(tput setaf 6)Documentation checks in permissive mode. Commit won't be aborted$(tput sgr0)"
  else
    echo -e "$(tput setaf 1)Error: $documentations_errors faulty documentation(s) found in puppet manifests. Commit will be aborted.$(tput sgr0)"
    exit 1
  fi
fi

exit 0
