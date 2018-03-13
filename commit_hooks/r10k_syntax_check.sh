#!/bin/bash
#
# This script assumes you have installed r10k and will perform a syntax check on the Puppetfile if existing
old_dir=$PWD
pf_dir=$(dirname $1)

echo "Performing a syntax check on the r10k Puppetfile:"
cd $pf_dir && r10k puppetfile check

if [[ $? -ne 0 ]]
then
  cd $old_dir
  exit 1
fi

cd $old_dir
exit 0
