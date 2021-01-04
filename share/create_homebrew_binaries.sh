#!/bin/bash

echo | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

mkdir /Users/vagrant/temp
cd /Users/vagrant/temp

brew test-bot --skip-setup --root-url=https://dl.bintray.com/apaffenholz/bottles-polymake --bintray-org=apaffenholz --tap=apaffenholz/polymake apaffenholz/polymake/polymake
