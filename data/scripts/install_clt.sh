#!/bin/bash

# $1: pkg name
echo ${1}

disk=`hdiutil attach ${2}/data/pkg/${1}  2>&1 | grep -o "disk[0-9]" | sort -u`
installer -verbose -pkg "/Volumes/Command Line Developer Tools/Command Line Tools.pkg" -target /
hdiutil detach $disk 

