#!/bin/bash

if [ ! -d /Library/Java/JavaVirtualMachines/jdk-$1.jdk ]; then
   if [ -f "/data/pkg/JDK $1.pkg" ]; then
       sudo -S installer -verbose -pkg "/data/pkg/JDK $1.pkg" -target /
   fi
fi