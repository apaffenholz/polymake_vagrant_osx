=== Vagrant environment for testing polymake builds on osx ===

== OSX vagrant boxes ==

Required naming scheme: osx-10.<version>

The Vagrant file handles version numbers 10,11,12,13,14

== Get necessary packages ==

Place pkg files in data/pkg

http://tug.org/cgi-bin/mactex-download/BasicTeX.pkg
https://www.xquartz.org/  (extract pkg from dmg)
https://www.python.org/downloads/mac-osx/
https://www.oracle.com/technetwork/java/javase/downloads/

place tar.bz2 in data/pkg
https://www.samba.org/ftp/ccache/ccache-3.6.tar.bz2

== Shared folders ==

Two folders are shared with the vm

- data as /data
- share as /share

the scripts install software into share to preserve it even if vm is recreated