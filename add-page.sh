#!/bin/bash

PROG=$(basename $0)
if [ $# -lt 1 ] ; then 
	echo "Usage: $PROG <page-title>"
	echo
	echo It will create a new blog entry markdown file for Octopress
	echo
	echo Example: 
	echo "  $PROG How to blog in Octopress"
	exit -1
fi

bundle exec rake new_post["$*"]
