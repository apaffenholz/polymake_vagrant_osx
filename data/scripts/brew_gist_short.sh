#!/bin/bash -x

brew_base=
src_dir=`mktemp -d`
install_dir=/Users/vagrant/poly_install
branch=master
repo=github

#------------------------------------------

full_repo="git@git.polymake.org:polymake"
if [ "$repo" == "github" ]; then
   full_repo="https://github.com/polymake/polymake.git"
fi

brew_binary=
if [[ -z $brew_base ]]; then
   brew_binary=/user/local/brew
else
   brew_binary=$brew_base/brew
fi

if [[ -f $brew_binary ]]; then
   $brew_base/bin/brew update
else 
   if [[ -z $brew_base ]]; then 
      echo | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
      $brew_binary doctor
   else 
      mkdir -p $brew_base && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C $brew_base
         if [[ ! -f $HOME/.bash_profile || ! `grep "PATH.*$brew_base/bin" $HOME/.bash_profile` ]]; then
            echo "export PATH=$brew_base/bin\${PATH+:\$PATH}" >> $HOME/.bash_profile
         fi
      $brew_binary doctor
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