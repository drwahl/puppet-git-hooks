#!/bin/bash
#
# This script assumes you have installed r10k and will perform a syntax check on the Puppetfile if existing

if [ -f Puppetfile ];
then
	echo "Performing a syntax check on the r10k Puppetfile:"
	r10k puppetfile check
fi

if [[ $? -ne 0 ]]
then
	        exit 1
	fi

