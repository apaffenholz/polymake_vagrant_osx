#!/bin/bash

bundle_dir=bundle_git
full_repo="https://github.com/polymake/polybundle.git"
#full_repo="file:///data/bundle"

curdir=`pwd`

mkdir -p $bundle_dir
cd $bundle_dir

if [[ ! -d .git ]]; then
   git clone $full_repo .
fi

cd $curdir

#tar xvfj /share/pkg/ccache-3.4.1.tar.bz2
#cd ccache-3.4.1
#./configure --prefix ~/ccache
#make && make install

#echo 'export PATH=/Users/vagrant/ccache/bin${PATH+:$PATH}' >> ~/.bash_profile

