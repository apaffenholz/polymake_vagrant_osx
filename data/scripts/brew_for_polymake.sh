#!/bin/bash

version=

while getopts ":v:" opt; do
  case $opt in
    v) version="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

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
if [[ "$version" == "10.15" ]]; then
   brew install openssl
fi

sudo -H pip3 install jupyter
sudo -H pip3 install jupyter_contrib_nbextensions
jupyter contrib nbextension install --user
jupyter nbextensions_configurator enable --user
sudo -H pip3 install jupyter_nbextensions_configurator
sudo -H pip3 install RISE

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
#cpanm JSON
cpanm install Net::SSLeay  

