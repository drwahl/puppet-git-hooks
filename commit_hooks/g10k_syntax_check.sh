#!/bin/bash
#
# This script assumes you have installed g10k and will perform a syntax check on the Puppetfile if existing

echo "Performing a syntax check on the g10k Puppetfile:"
g10k -puppetfile "$1" check

if [[ $? -ne 0 ]]
then
	exit 1
fi
