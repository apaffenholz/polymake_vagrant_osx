#!/bin/bash

if [ ! -d /Applications/Utilities/XQuartz.app ]; then
   sudo -S installer -verbose -pkg "/data/pkg/${1}.pkg" -target /
fi
