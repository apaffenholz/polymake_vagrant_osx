#!/bin/bash

if [ ! -d /Library/Java/JavaVirtualMachines/jdk-$1.jdk ]; then
   if [ -f "$2/data/pkg/JDK $1.pkg" ]; then
       sudo -S installer -verbose -pkg "$2/data/pkg/JDK $1.pkg" -target /
   fi
fi