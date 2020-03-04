#!/bin/bash

# $1: machine name
# $2: pkg name
# $3: path prefix, if we cannot install into /

if [ ! -f ${3}/share/${1}/dependencies/bin/ccache ]; then
    mkdir -p ${3}/share/${1}/dependencies/bin
    if [[ ! -f $HOME/.bash_profile || ! `grep "export PATH.*/share/${1}/dependencies/bin" $HOME/.bash_profile` ]]; then
        echo "export PATH=${3}/share/${1}/dependencies/bin${PATH+:$PATH}" > $HOME/.bash_profile
    fi
    mkdir -p ${3}/share/${1}/src
    cd ${3}/share/${1}/src
    tar xvfj ${3}/data/pkg/${2}
    make install
fi

