#!/bin/bash

brew_base=/usr/local
nonstandard=0

if [ ${1} ]; then
   brew_base=${1}
   nonstandard=1
fi
if [ -f $brew_base/brew ]; then
   $brew_base/bin/brew update
else 
   if [ ${1} ]; then 
      mkdir -p ${1} && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C ${1}
      if [[ nonstandard -eq 1 ]]; then 
         if [[ ! -f $HOME/.bash_profile || ! `grep "PATH.*$brew_base/bin" $HOME/.bash_profile` ]]; then
            echo "export PATH=$brew_base/bin\${PATH+:\$PATH}" >> $HOME/.bash_profile
         fi
      fi
      brew doctor
   else
      echo | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
      brew doctor
   fi
fi

if [ -f /Users/vagrant/perl5/perlbrew/bin/perlbrew ]; then 
   perlbrew self-upgrade
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
