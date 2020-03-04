#!/bin/bash

path_prefix=

while getopts ":m:b:r:p:" opt; do
  case $opt in
    m) name="$OPTARG"
    ;;
    b) branch="$OPTARG"
    ;;
    r) repo="$OPTARG"
    ;;
    p) path_prefix="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

curdir=`pwd`

full_repo="git@git.polymake.org:polymake"
if [[ "$repo" == "github" ]]; then
   full_repo="https://github.com/polymake/polymake.git"
fi

cd $curdir
cd $path_prefix/data/scripts
BASE_DIR=$curdir \
  TAR_DIR=$path_prefix/share/tar/ \
  SRC_DIR=$path_prefix/share/$name/src \
  POLYMAKE_SRC_DIR=$path_prefix/share/$repo \
  POLYMAKE_SERVER=$full_repo \
  INSTALL_DIR=$path_prefix/share/$name/dependencies/ \
  INSTALL_POLYMAKE_DIR=$path_prefix/share/$name/install/$repo/$name.$branch/ \
  CCACHE=$path_prefix/share/$name/dependencies/bin/ccache \
  NAME=$name \
  ./polymake_install.sh

if [[ ! -f $HOME/.bash_profile || ! `grep "PERL5LIB=$path_prefix/share/$name/dependencies/perl-modules/lib/perl5/site_perl:$path_prefix/share/$name/dependencies/perl-modules/lib/perl5/darwin-thread-multi-2level" $HOME/.bash_profile` ]]; then
   echo "export PERL5LIB=$path_prefix/share/$name/dependencies/perl-modules/lib/perl5/site_perl:$path_prefix/share/$name/dependencies/perl-modules/lib/perl5/darwin-thread-multi-2level${PERL5LIB+:$PERL5LIB}" >> $HOME/.bash_profile
fi
if [[ ! -f $HOME/.bash_profile || ! `grep "PATH=.*/share/$name/install/$repo/$name.$branch/bin" $HOME/.bash_profile` ]]; then
   echo "export PATH=$path_prefix/share/$name/install/$repo/$name.$branch/bin:$path_prefix/share/$name/dependencies/bin${PATH+:$PATH}" >> $HOME/.bash_profile
fi

# we only link in the default directory
if [[ ! -d /Users/vagrant/polymake_src ]]; then 
   ln -s $path_prefix/share/$repo /Users/vagrant/polymake_src
fi

echo "polymake --script jupyter --ip=0.0.0.0 --port=8888 --no-browser" > $path_prefix/share/$name/dependencies/bin/polymake_jupyter
chmod u+x $path_prefix/share/$name/dependencies/bin/polymake_jupyter

cd $curdir