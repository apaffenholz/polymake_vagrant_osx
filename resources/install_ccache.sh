#!/bin/bash

if [ ! -f /share/${1}/dependencies/bin/ccache ]; then
    mkdir -p /share/${1}/dependencies/bin
    if [[ ! -f $HOME/.bash_profile || ! `grep "export PATH.*/share/${1}/dependencies/bin" $HOME/.bash_profile` ]]; then
        echo "export PATH=/share/${1}/dependencies/bin${PATH+:$PATH}" > $HOME/.bash_profile
    fi
    mkdir -p /share/${1}/src
    cd /share/${1}/src
    tar xvfj /data/pkg/${2}
    make install
fi

