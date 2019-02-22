#!/bin/bash -x

currdir=`pwd`;

if [ -d /sw ]; then
   . /sw/bin/init.sh
   fink self-update
   fink update-all
else
   mkdir -p /Users/vagrant/finkinstall
   cd /Users/vagrant/finkinstall
   curl -O -L ${1}${2}/${3}
   tar xvfz ${3}
   cd InstallFink
   yes "" | "./Install Fink.tool"
   . /sw/bin/init.sh
   cd /Users/vagrant
   rm -rf /Users/vagrant/finkinstall
fi

fink update-all

grep ". /sw/bin/init.sh" $HOME/.bash_profile || echo ". /sw/bin/init.sh" >> $HOME/.bash_profile

cd $currdir;
