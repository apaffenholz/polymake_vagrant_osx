#!/bin/bash

brew_base=/usr/local
nonstandard=0
version=

while getopts ":b:v:" opt; do
  case $opt in
    b) brew_base="$OPTARG"
    ;;
    v) version="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

if [ "$brew_base" != "/usr/local" ]; then
   nonstandard=1
fi
if [ -f $brew_base/brew ]; then
   $brew_base/bin/brew update
else 
   if [[ nonstandard -eq 1 ]]; then 
      mkdir -p $brew_base && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C $brew_base
      if [[ ! -f $HOME/.bash_profile || ! `grep "PATH.*$brew_base/bin" $HOME/.bash_profile` ]]; then
         echo "export PATH=$brew_base/bin\${PATH+:\$PATH}" >> $HOME/.bash_profile
      fi
      $brew_base/bin/brew doctor
   else
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      $brew_base/bin/brew doctor
   fi
fi
if [[ "$version" == "10.15" ]]; then
   if [[ ! -f $HOME/.bash_profile || ! `grep "export CPATH=/Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk/System/Library/Perl/5.18/darwin-thread-multi-2level/CORE/" .bash_profile` ]]; then 
      echo "export CPATH=/Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk/System/Library/Perl/5.18/darwin-thread-multi-2level/CORE/${CPATH+:$CPATH}" >> $HOME/.bash_profile
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
