#!/bin/bash

while getopts ":m:b:r:" opt; do
  case $opt in
    m) name="$OPTARG"
    ;;
    b) branch="$OPTARG"
    ;;
    r) repo="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

curdir=`pwd`

full_repo="git@git.polymake.org:polymake"
if [ "$repo" == "github" ]; then
   full_repo="https://github.com/polymake/polymake.git"
fi

cd $curdir
cd /data/scripts
BASE_DIR=$curdir \
  TAR_DIR=/share/tar/ \
  SRC_DIR=/share/$name/src \
  POLYMAKE_SRC_DIR=/share/$repo \
  POLYMAKE_SERVER=$full_repo \
  INSTALL_DIR=/share/$name/dependencies/ \
  INSTALL_POLYMAKE_DIR=/share/$name/install/$repo/$name.$branch/ \
  CCACHE=/share/$name/dependencies/bin/ccache \
  NAME=$name \
  ./polymake_install.sh

if [[ ! -f $HOME/.bash_profile || ! `grep "PERL5LIB=/share/$name/dependencies/perl-modules/lib/perl5/site_perl:/share/$name/dependencies/perl-modules/lib/perl5/darwin-thread-multi-2level" $HOME/.bash_profile` ]]; then
   echo "export PERL5LIB=/share/$name/dependencies/perl-modules/lib/perl5/site_perl:/share/$name/dependencies/perl-modules/lib/perl5/darwin-thread-multi-2level${PERL5LIB+:$PERL5LIB}" >> $HOME/.bash_profile
fi
if [[ ! -f $HOME/.bash_profile || ! `grep "PATH=.*/share/$name/install/$repo/$name.$branch/bin" $HOME/.bash_profile` ]]; then
   echo "export PATH=/share/$name/install/$repo/$name.$branch/bin:/share/$name/dependencies/bin${PATH+:$PATH}" >> $HOME/.bash_profile
fi

# we only link in the default directory
if [[ ! -d /Users/vagrant/polymake_src ]]; then 
   ln -s /share/$repo /Users/vagrant/polymake_src
fi

echo "polymake --script jupyter --ip=0.0.0.0 --port=8888 --no-browser" > /share/$name/dependencies/bin/polymake_jupyter
chmod u+x /share/$name/dependencies/bin/polymake_jupyter

cd $curdir