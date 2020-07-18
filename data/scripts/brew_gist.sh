#!/bin/bash

BREW_BASE=
SRC_DIR=`mktemp -d`
INSTALL_DIR=/Users/vagrant/poly_install
BRANCH=master
REPO=github
BREW_INSTALLED=0
PERLBREW_INSTALLED=0

#------------------------------------------

xcode-select -p 1>/dev/null
if [ ! $? ]; then
echo "Please install the command line tools first. Run 'xcode-select --install' in a terminal";
exit;
fi

FULL_REPO="git@git.polymake.org:polymake"
if [ "$REPO" == "github" ]; then
   FULL_REPO="https://github.com/polymake/polymake.git"
fi

brew_binary=
if [[ -z $BREW_BASE ]]; then
   brew_binary=/usr/local/bin/brew
else
   brew_binary=$BREW_BASE/bin/brew
fi

if [[ -f $brew_binary ]]; then
   BREW_INSTALLED=1
else
   echo "this script will install homebrew on your computer."
   read -p "Continue (y/n)? " -n 1 -r
   if [[ ! $REPLY =~ ^[Yy]$ ]]
   then
      exit;
   fi
fi

if [[ -f $brew_binary ]]; then
   $brew_binary update
else 
   if [[ -z $BREW_BASE ]]; then 
      echo | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
      $brew_binary doctor
   else 
      mkdir -p $BREW_BASE && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C $BREW_BASE
         if [[ ! -f $HOME/.bash_profile || ! `grep "PATH.*$BREW_BASE/bin" $HOME/.bash_profile` ]]; then
            echo "export PATH=$BREW_BASE/bin\${PATH+:\$PATH}" >> $HOME/.bash_profile
         fi
      $brew_binary doctor
   fi
fi

if [[ -f ~/perl5/perlbrew/bin/perlbrew ]]; then
   PERLBREW_INSTALLED=1
else
   echo "this script will install perlbrew on your computer."
   read -p "Continue (y/n)? " -n 1 -r
   if [[ ! $REPLY =~ ^[Yy]$ ]]
   then
      exit;
   fi
fi

if [[ -f ~/perl5/perlbrew/bin/perlbrew ]]; then 
   ~/perl5/perlbrew/bin/perlbrew self-upgrade
else 
   \curl -L http://install.perlbrew.pl | bash
fi
if [[ ! -f $HOME/.bash_profile || ! `grep "export PERL5LIB=$HOME/perl5/lib/perl5:$HOME/perl5" .bash_profile` ]]; then 
   echo "export PERL5LIB=$HOME/perl5/lib/perl5:$HOME/perl5${PERL5LIB+:$PERL5LIB}" >> $HOME/.bash_profile
fi
if [[ ! -f $HOME/.bash_profile || ! `grep "source ~/perl5/perlbrew/etc/bashrc" $HOME/.bash_profile` ]]; then
   echo "source ~/perl5/perlbrew/etc/bashrc" >> $HOME/.bash_profile
fi
if [[ ! -f $HOME/.bash_profile || ! `grep 'export ARCHFLAGS="-arch x86_64"' $HOME/.bash_profile` ]]; then
   echo 'export ARCHFLAGS="-arch x86_64"' >> $HOME/.bash_profile
fi

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
cpanm install Net::SSLeay
pip3 install jupyter

yes N | perlbrew install-cpanm
cpanm --local-lib=~/perl5 local::lib && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
brew link --force readline
configure_args=''
if [[ $nonstandard -eq 1 ]]; then 
   configure_args="--cflags=-I$BREW_BASE/include --libs=-L$BREW_BASE/lib --prefix=$BREW_BASE"
else
   configure_args='--prefix=/usr/local'
fi
cpanm  --configure-args $configure_args Term::ReadLine::Gnu
brew unlink readline
cpanm XML::LibXSLT
cpanm SVG
cpanm Moo
# FIXME apparently we need to pin an older version of this module, otherwise everything else fails
cpanm ZEFRAM/Module-Runtime-0.013.tar.gz
cpanm MongoDB
cpanm JSON

curdir=`pwd`
mkdir -p $SRC_DIR
cd $SRC_DIR

if [[ ! -d .git ]]; then
   git clone $FULL_REPO .
   git checkout $BRANCH
fi

if [ -z $INSTALL_DIR ]; then 
   ./configure
   ninja -C build/Opt -l2 
   sudo ninja -C build/Opt -l2 install
else
   ./configure --prefix=$INSTALL_DIR 
   ninja -C build/Opt -l2 install
fi

cd $curdir