#!/bin/bash

if [ ! -d /usr/local/texlive ]; then
   if [ ! -f ${2}/data/pkg/${1}.pkg ]; then
      cd ${2}/data/pkg
      curl -O -L http://ftp.uni-erlangen.de/mirrors/CTAN/systems/mac/mactex/${1}.pkg
   fi 
   sudo -S installer -verbose -pkg "${2}/data/pkg/${1}.pkg" -target /
fi
