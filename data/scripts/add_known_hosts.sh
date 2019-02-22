#!/bin/bash

if [[ ! -f $HOME/.ssh/known_hosts || ! `grep "git.polymake.org" $HOME/.ssh/known_hosts` ]]; then 
   echo "git.polymake.org,130.149.13.185 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOynDjBEpuHi6ptaqEHK/hb1awKblCtfOJ7Ilnq1HHj+" >> $HOME/.ssh/known_hosts
fi