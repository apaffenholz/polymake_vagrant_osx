#!/bin/bash

if [ ! -d /Library/Frameworks/Python.Framework/Versions/${1} ]; then
   if [ ! -f ${3}/data/pkg/${2}.pkg ]; then
      cd ${3}/data/pkg
      curl -O -L https://www.python.org/ftp/python/${1}/${2}.pkg
   fi
   sudo -S installer -verbose -pkg "${3}/data/pkg/${2}.pkg" -target /
fi

pip3 install jupyter

if [[ ! `grep "/Library/Frameworks/Python.framework/" /etc/bashrc` ]]; then
   sudo echo "export PATH=/Library/Frameworks/Python.framework/Versions/${1}/bin${PATH+:$PATH}" >> /etc/bashrc
fi 
