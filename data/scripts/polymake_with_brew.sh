#!/bin/bash

while getopts ":m:b:r:s:" opt; do
  case $opt in
    m) name="$OPTARG"
    ;;
    b) branch="$OPTARG"
    ;;
    r) repo="$OPTARG"
    ;;
    s) src_dir="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

if [[ ! $src_dir ]]; then
  src_dir="/share/src/$repo"
fi

full_repo="git@git.polymake.org:polymake"
if [ "$repo" == "github" ]; then
   full_repo="https://github.com/polymake/polymake.git"
fi

curdir=`pwd`
mkdir -p $src_dir
cd $src_dir

# we only link in the default directory
if [[ "$src_dir" == /share/src/$repo ]]; then
   if [[ ! -d /Users/vagrant/polymake_src ]]; then 
      ln -s $src_dir /Users/vagrant/polymake_src
   fi
fi

if [[ ! -d .git ]]; then
   git clone $full_repo .
   git checkout $branch
fi

echo "./configure --prefix=/share/$name/install/$repo/$name.$branch --with-ccache=/usr/local/bin/ccache --build $name" > polymake_configure.$name
chmod u+x polymake_configure.$name
. polymake_configure.$name
ninja -C build.$name/Opt -l2 install

grep "export \$PATH" $HOME/.bash_profile &&
sed -i "" "s|export PATH=[a-zA-Z0-9/]*bin|export PATH=/share/$name/install/$repo/$name.$branch/bin|" || echo "export PATH=/share/$name/install/$repo/$name.$branch/bin:/$HOME/bin${PATH+:$PATH}" >> $HOME/.bash_profile

mkdir -p $HOME/bin
cat > $HOME/bin/polymake_jupyter <<EOF
#!/bin/bash

dir=/share/jupyter_notebooks
if [ $1 ]; then
  dir=$1
fi

polymake --script jupyter --ip=0.0.0.0 --port=8888 --no-browser --notebook-dir=$dir

EOF
chmod u+x $HOME/bin/polymake_jupyter

source $HOME/.bash_profile

cd $curdir