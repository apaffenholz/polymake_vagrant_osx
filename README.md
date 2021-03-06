Vagrant environment for testing polymake builds on osx
======

OSX vagrant boxes
------

 * Required naming scheme for vagrant boxes: osx-10.<version>
 * The Vagrant file handles version numbers 10,11,12,13,14
 * boxes must have command line tools preinstalled
  
vms created by Vagrantfile
------
 
 * osx.<version>.plain: downlaod and compile all dependences for polymake 
 * osx.<version>.brew: resolve dependences with brew before compiling polymake
 * osx.<version>.fink: resolve dependences with fink before compiling polymake (currently untested)
 * osx.<version>.bundle: create a polymake binary bundle for the osx version <version>

Get necessary packages
------

Place pkg files in data/pkg

 * latex distribution: http://tug.org/cgi-bin/mactex-download/BasicTeX.pkg
 * Xquartz (needed for fink installation) https://www.xquartz.org/  (extract pkg from dmg)
 * Testing Jupyter notebooks: https://www.python.org/downloads/mac-osx/
 * Java: Download from https://www.oracle.com/technetwork/java/javase/downloads/, it is necessary to accept license agreement
 * ccache, place tar.bz2 in data/pkg: https://www.samba.org/ftp/ccache/ccache-3.6.tar.bz2

Shared folders
------

Two folders are shared with the vm

- data as /data
- share as /share

the scripts install software into share to preserve it even if vm is recreated
