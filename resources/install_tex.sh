#!/bin/bash

if [ ! -d /usr/local/texlive ]; then
   if [ ! -f /data/pkg/${1}.pkg ]; then
      cd /data/pkg
      curl -O -L http://ftp.uni-erlangen.de/mirrors/CTAN/systems/mac/mactex/${1}.pkg
   fi 
   sudo -S installer -verbose -pkg "/data/pkg/${1}.pkg" -target /
fi
