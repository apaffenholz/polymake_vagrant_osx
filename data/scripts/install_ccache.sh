#!/bin/bash

echo ${1}${2} > name.log

mkdir -p ${3}/share/${1}/dependencies/bin
if [ ! -f ${3}/share/${1}/dependencies/bin/ccache ]; then
    if [ ! -f ${3}/data/pkg/${2}.tar.bz2 ]; then
       cd ${3}/data/pkg
       curl -O -L https://www.samba.org/ftp/ccache/${2}.tar.bz2
    fi
    mkdir -p ${3}/share/${1}/src
    cd ${3}/share/${1}/src
    tar xvfj ${3}/data/pkg/${2}.tar.bz2
    cd ${2}
    ./configure --prefix=${3}/share/${1}/dependencies/
    make install
fi
if [[ ! -f $HOME/.bash_profile || ! `grep "export PATH.*/share/${1}/dependencies/bin" $HOME/.bash_profile` ]]; then
    echo "export PATH=${3}/share/${1}/dependencies/bin${PATH+:$PATH}" >> $HOME/.bash_profile
fi

