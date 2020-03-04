#!/bin/bash

path_prefix=$1

bundle_git=/Users/vagrant/bundle_git
build_dir=/Users/vagrant/bundle_build
curdir=`pwd`

mkdir -p $build_dir
cd $build_dir
$bundle_git/build_scripts/build_bundle

cd $curdir

mkdir -p $path_prefix/share/bundles

MACVERSION=$(sw_vers | grep -o "10[.][0-9]\+")
PERLVERSION=$(perl --version | grep -o "5[.][0-9]*[.][0-9]")
bundlename=polybundle-macos-${MACVERSION}-perl-${PERLVERSION}
v=`ls $path_prefix/share/bundles | grep $bundlename | wc -l`
v=$((v+1))
bundlename=${bundlename}-v${v}.dmg
cp $build_dir/polybundle.dmg $path_prefix/share/bundles/${bundlename}