#!/bin/bash

echo ${1}${2} > name.log

mkdir -p /share/${1}/dependencies/bin
if [ ! -f /share/${1}/dependencies/bin/ccache ]; then
    if [ ! -f /data/pkg/${2}.tar.bz2 ]; then
       cd /data/pkg
       curl -O -L https://www.samba.org/ftp/ccache/${2}.tar.bz2
    fi
    mkdir -p /share/${1}/src
    cd /share/${1}/src
    tar xvfj /data/pkg/${2}.tar.bz2
    cd ${2}
    ./configure --prefix=/share/${1}/dependencies/
    make install
fi
if [[ ! -f $HOME/.bash_profile || ! `grep "export PATH.*/share/${1}/dependencies/bin" $HOME/.bash_profile` ]]; then
    echo "export PATH=/share/${1}/dependencies/bin${PATH+:$PATH}" >> $HOME/.bash_profile
fi

