#!/bin/bash

path_prefix=

while getopts ":m:b:r:" opt; do
  case $opt in
    m) name="$OPTARG"
    ;;
    b) branch="$OPTARG"
    ;;
    r) repo="$OPTARG"
    ;;
    s) src_dir="$OPTARG"
    ;;
    p) path_prefix="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

if [[ ! $src_dir ]]; then
  src_dir="$path_prefix/share/src/$repo"
fi

full_repo="git@git.polymake.org:polymake"
if [ "$repo" == "github" ]; then
   full_repo="https://github.com/polymake/polymake.git"
fi

curdir=`pwd`
mkdir -p $src_dir
cd $src_dir

# we only link in the default directory
if [[ "$src_dir" == $path_prefix/share/src/$repo ]]; then
   if [[ ! -d /Users/vagrant/polymake_src ]]; then 
      ln -s $src_dir /Users/vagrant/polymake_src
   fi
fi

if [[ ! -d .git ]]; then
   echo "Cloning $full_repo in $src_dir"
   git clone $full_repo .
   git checkout $branch
fi

. /sw/bin/init.sh

echo "ANT_HOME=/sw/lib/ant/ ./configure --prefix=$path_prefix/share/$name/install/$repo/$name.$branch/ --build $name" > polymake_configure.$name
chmod u+x polymake_configure.$name
. polymake_configure.$name
ninja -C build.$name/Opt -l2 install

grep "export \$PATH" $HOME/.bash_profile &&
sed -i "" "s|export PATH=[a-zA-Z0-9/]*bin|export PATH=$path_prefix/share/$name/install/$repo/$name.$branch/bin|" || echo "export PATH=$path_prefix/share/$name/install/$repo/$name.$branch/bin:/$HOME/bin${PATH+:$PATH}" >> $HOME/.bash_profile

mkdir -p $HOME/bin
echo "polymake --script jupyter --ip=0.0.0.0 --port=8888 --no-browser" > $HOME/bin/polymake_jupyter
chmod u+x $HOME/bin/polymake_jupyter

cd $currdir