#!/bin/bash

source $HOME/.bash_profile

brew install gmp
brew install mpfr
brew install boost
brew install readline
brew install ant
brew install ppl
brew install python3
brew install ninja
brew install ccache
sudo -H pip3 install jupyter

yes N | perlbrew install-cpanm
cpanm --local-lib=~/perl5 local::lib && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
# FIXME apparently we need to pin an older version of this module, otherwise everything else fails
brew link --force readline
configure_args=''
if [ ${1} ]; then 
   configure_args="--cflags=-I${1}/include --libs=-L${1}/lib --prefix=${1}"
else
   configure_args='--prefix=/usr/local'
fi
cpanm  --configure-args $configure_args Term::ReadLine::Gnu
brew unlink readline
cpanm XML::LibXSLT
cpanm SVG
cpanm Moo
cpanm ZEFRAM/Module-Runtime-0.013.tar.gz
cpanm MongoDB
cpanm JSON
