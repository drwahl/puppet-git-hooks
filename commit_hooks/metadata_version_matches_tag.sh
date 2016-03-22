#!/bin/bash -u

# This script expects $1 to be passed and for $1 to be the filesystem location
# 
# This script expects $2 to be passed and for it to be the tag name

errors=0

module_path=$1
tag=$2

error_msg=$(mktemp /tmp/error_msg_tag-version.XXXXXX)
metadata=$(mktemp /tmp/metadata_version.XXXXXX)

echo -e "$(tput setaf 6)Checking metadata matches tag for $tag $(tput sgr0)"

ruby -e "require 'json'; metadata=JSON.parse(File.read('$module_path/metadata.json')); puts metadata['version']" 2> $error_msg > $metadata
if [ $? -ne 0 ]; then
    cat $error_msg | sed -e "s/^/$(tput setaf 1)/" -e "s/$/$(tput sgr0)/"
    errors=`expr $errors + 1`
    echo -e "$(tput setaf 1)Error: json syntax error in $module_path (see above)$(tput sgr0)"
    exit 1
fi
rm -f $error_msg

meta_tag=$(cat $metadata; rm -f $metadata)
case $meta_tag in
  $tag)
    true
  ;;
  [vV]$tag)
    true
  ;;
  "v $tag")
    true
  ;;
  "V $tag")
    true
  ;;
  [vV].$tag)
    true
  ;;
  "v. $tag")
    true
  ;;
  "V. $tag")
    true
  ;;
  *)
    echo -e "$(tput setaf 1)Error: metadata.json contains $meta_tag but tag is $tag $(tput sgr0)"
    errors=`expr $errors + 1`
  ;;
esac

if [[ $errors -ne 0 ]]; then
    echo -e "$(tput setaf 1)Error: error(s) found in metadata.json file.  Commit will be aborted.$(tput sgr0)"
    exit 1
fi

exit 0
