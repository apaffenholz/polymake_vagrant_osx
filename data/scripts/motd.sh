#!/bin/bash

echo > /etc/motd
for (( i=1; i<=$#; i+=2 )); do
    j=$((i+1))
    echo "${!i} ${!j}" >> /etc/motd
done
