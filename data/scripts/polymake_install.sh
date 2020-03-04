#!/bin/bash


PWD=`pwd`
CURDIR=${BASE_DIR:-$PWD}
TEMP_DIR=$CURDIR/tmp

CCACHE_BIN=
if [ `command -v ccache` ]; then
    CCACHE_BIN=`command -v ccache`;
fi;

TAR_DIR=${TAR_DIR:-$TEMP_DIR/tar}
SRC_DIR=${SRC_DIR:-$TEMP_DIR/src}
POLYMAKE_SRC_DIR=${POLYMAKE_SRC_DIR:-$SRC_DIR/github}
POLYMAKE_SERVER=${POLYMAKE_SERVER:-https://github.com/polymake/polymake.git}
INSTALL_DIR=${INSTALL_DIR:-$CURDIR/polymake}
INSTALL_POLYMAKE_DIR=${INSTALL_POLYMAKE_DIR:-$INSTALL_DIR/polymake}
CCACHE_BIN=${CCACHE:-CCACHE_BIN}
NAME=${NAME:-}

SED=sed
CURL='curl -O -L'

ANTVERSION=1.10.5
ANTNAME=apache-ant-$ANTVERSION-bin.tar.bz2
ANTBASE=http://artfiles.org/apache.org//ant/binaries

FTI2VERSION=1.6.9
FTI2VERSION_DIR=1_6_9
FTI2NAME=4ti2-$FTI2VERSION.tar.gz
FTI2BASE=https://github.com/4ti2/4ti2/releases/download/Release_$FTI2VERSION_DIR

TERMRLGNUVERSION=1.35
TERMRLGNUNAME=Term-ReadLine-Gnu-$TERMRLGNUVERSION.tar.gz
TERMRLGNUBASE=http://search.cpan.org/CPAN/authors/id/H/HA/HAYASHI

LIBXSLTVERSION=1.96
LIBXSLTNAME=XML-LibXSLT-$LIBXSLTVERSION.tar.gz
LIBXSLTBASE=http://search.cpan.org/CPAN/authors/id/S/SH/SHLOMIF

CANARYVERSION=2012
CANARYNAME=Canary-Stability-$CANARYVERSION.tar.gz
CANARYBASE=https://cpan.metacpan.org/authors/id/M/ML/MLEHMANN

JSONXSVERSION=4.02
JSONXSNAME=JSON-XS-$JSONXSVERSION.tar.gz
JSONXSBASE=https://cpan.metacpan.org/authors/id/M/ML/MLEHMANN

JSONVERSION=4.02
JSONNAME=JSON-$JSONVERSION.tar.gz
JSONBASE=https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI

SVGVERSION=2.84
SVGNAME=SVG-$SVGVERSION.tar.gz
SVGBASE=http://search.cpan.org/CPAN/authors/id/M/MA/MANWAR

BOOSTVERSION=1_66_0
BOOSTVERSIONDIR=1.66.0
BOOSTNAME=boost_$BOOSTVERSION.tar.bz2
BOOSTBASE=https://dl.bintray.com/boostorg/release/$BOOSTVERSIONDIR/source

GMPVERSION=6.1.2
GMPMINORVERSION=
GMPNAME=gmp-$GMPVERSION$GMPMINORVERSION.tar.bz2
GMPBASE=https://gmplib.org/download/gmp

MPFRVERSION=4.0.1
MPFRNAME=mpfr-$MPFRVERSION.tar.bz2
MPFRBASE=http://www.mpfr.org/mpfr-$MPFRVERSION

READLINEVERSION=6.3
READLINENAME=readline-$READLINEVERSION.tar.gz
READLINEBASE=ftp://ftp.cwru.edu/pub/bash/

AUTOCONFVERSION=2.69
AUTOCONFNAME=autoconf-$AUTOCONFVERSION.tar.gz
AUTOCONFBASE=http://ftp.gnu.org/gnu/autoconf

AUTOMAKEVERSION=1.14
AUTOMAKENAME=automake-$AUTOMAKEVERSION.tar.gz
AUTOMAKEBASE=http://ftp.gnu.org/gnu/automake

LIBTOOLVERSION=2.4
LIBTOOLNAME=libtool-$LIBTOOLVERSION.tar.gz
LIBTOOLBASE=http://ftp.gnu.org/gnu/libtool

NTLVERSION=11.3.2
NTLNAME=ntl-$NTLVERSION.tar.gz
NTLBASE=http://www.shoup.net/ntl

CDDLIBVERSION=094h
CDDLIBNAME=cddlib-$CDDLIBVERSION.tar.gz
CDDLIBBASE=ftp://ftp.math.ethz.ch/users/fukudak/cdd

GLPKVERSION=4.61
GLPKNAME=glpk-$GLPKVERSION.tar.gz
GLPKBASE=http://ftp.gnu.org/gnu/glpk

NINJAVERSION="v1.8.2"
NINJANAME=ninja-mac.zip
NINJABASE=https://github.com/ninja-build/ninja/releases/download/$NINJAVERSION

SINGULARVERSION=4.0.3
PPLVERSION=1.2
NORMALIZVERSION=3.5.0
LRSVERSION=4.2
NAUTYVERSION=
JREALITYVERSION=
PERMLIBVERSION=

JNIHEADERS="/System/Library/Frameworks/JavaVM.framework/Headers/"

mkdir -p $TAR_DIR
mkdir -p $INSTALL_DIR
mkdir -p $TEMP_DIR
mkdir -p $SRC_DIR
mkdir -p $TAR_DIR

function set_prefix {
    exec 1>&3 2>&4
    exec 3>&1 4>&2 1> >(sed "s/^/$1: /") 2>&1
}

function fetch_src {
    cd $TAR_DIR
    if [ ! -f  $1 ]; then 
        echo "fetching $1"
        $CURL $2/$1
    fi
    cd $CURDIR
} 

exec 3>&1 4>&2

# fetch sources
set_prefix "fetch sources"
fetch_src $ANTNAME $ANTBASE
fetch_src $FTI2NAME $FTI2BASE
fetch_src $TERMRLGNUNAME $TERMRLGNUBASE
fetch_src $LIBXSLTNAME $LIBXSLTBASE
fetch_src $CANARYNAME $CANARYBASE
fetch_src $JSONXSNAME $JSONXSBASE
fetch_src $JSONNAME $JSONBASE
fetch_src $SVGNAME $SVGBASE
fetch_src $BOOSTNAME $BOOSTBASE
fetch_src $GMPNAME $GMPBASE
fetch_src $MPFRNAME $MPFRBASE
fetch_src $READLINENAME $READLINEBASE
fetch_src $AUTOCONFNAME $AUTOCONFBASE
fetch_src $AUTOMAKENAME $AUTOMAKEBASE
fetch_src $LIBTOOLNAME $LIBTOOLBASE
fetch_src $NTLNAME $NTLBASE
fetch_src $CDDLIBNAME $CDDLIBBASE
fetch_src $GLPKNAME $GLPKBASE
fetch_src $NINJANAME $NINJABASE

echo "extracting ant"
set_prefix "extracting ant"
cd $INSTALL_DIR
if [ ! -d ant ]; then 
    tar xvfj $TAR_DIR/$ANTNAME
    rm -rf ant 
    mv apache-ant-$ANTVERSION ant
fi
cd $CURDIR

echo "extraxcting boost"
set_prefix "extraxcting boost"
cd $INSTALL_DIR
if [ ! -d boost ]; then 
    tar xvfj $TAR_DIR/$BOOSTNAME
    rm -rf boost 
    mv boost_$BOOSTVERSION boost
fi
cd $CURDIR

echo "building readline"
set_prefix "building readline"
cd $SRC_DIR
if [ ! -d readline-$READLINEVERSION ]; then
    tar xvfz $TAR_DIR/$READLINENAME
fi
cd readline-$READLINEVERSION
CC="ccache clang" CXX="ccache clang++" ./configure --prefix=$INSTALL_DIR && make && make install
cd $CURDIR

echo "building gmp"
set_prefix "building gmp"
cd $SRC_DIR 
if [ ! -d gmp-$GMPVERSION ]; then
    tar xvfj $TAR_DIR/$GMPNAME
fi
cd gmp-$GMPVERSION
CC="ccache clang" CXX="ccache clang++" ./configure --prefix=$INSTALL_DIR --enable-cxx && make && make install
cd $CURDIR

echo "building mpfr"
set_prefix "building mpfr"
cd $SRC_DIR
if [ ! -d mpfr-$MPFRVERSION ]; then
    tar xvfj $TAR_DIR/$MPFRNAME
fi
cd mpfr-$MPFRVERSION
CC="ccache clang" CXX="ccache clang++" ./configure --prefix=$INSTALL_DIR --with-gmp=$INSTALL_DIR && make && make install
cd $CURDIR

echo "building cddlib"
set_prefix "building cddlib"
cd $SRC_DIR 
if [ ! -d cddlib-$CDDLIBVERSION ]; then
    tar xvfz $TAR_DIR/$CDDLIBNAME
fi
cd cddlib-$CDDLIBVERSION
CC="ccache clang" CXX="ccache clang++" ./configure --prefix=$INSTALL_DIR CFLAGS=-I$INSTALL_DIR/include LDFLAGS=-L$INSTALL_DIR/lib
make && make install
cd $CURDIR

echo "building glpk"
set_prefix "building glpk"
cd $SRC_DIR
if [ ! -d glpk-$GLPKVERSION ]; then
    tar xvfz $TAR_DIR/$GLPKNAME
fi
cd glpk-$GLPKVERSION 
CC="ccache clang" CXX="ccache clang++" ./configure --prefix=$INSTALL_DIR && make && make install
cd $CURDIR

echo "building 4ti2"
set_prefix "building 4ti2"
cd $SRC_DIR 
if [ ! -d 4ti2-$FTI2VERSION ]; then
    tar xvfz $TAR_DIR/$FTI2NAME
fi
cd 4ti2-$FTI2VERSION
CC="ccache clang" CXX="ccache clang++" ./configure --prefix=$INSTALL_DIR --with-gmp=$INSTALL_DIR --with-glpk=$INSTALL_DIR && make && make install
cd $CURDIR

echo "building flint2"
set_prefix "building flint2"
cd $SRC_DIR
if [ ! -d flint2/.git ]; then 
    git clone https://github.com/wbhart/flint2.git flint2; 
else 
    cd flint2; git pull; 
fi
cd $CURDIR
cd $SRC_DIR/flint2; 
CC="ccache clang" CXX="ccache clang++" ./configure --prefix=$INSTALL_DIR --with-gmp=$INSTALL_DIR --with-mpfr=$INSTALL_DIR
make && make install
cd $CURDIR

echo "building libtool"
set_prefix "building libtool"
cd $SRC_DIR
if [ ! -d libtool-$LIBTOOLVERSION ]; then
    tar xvfz $TAR_DIR/$LIBTOOLNAME
fi
cd libtool-$LIBTOOLVERSION 
CC="ccache clang" CXX="ccache clang++" ./configure --prefix=$INSTALL_DIR/local && make && make install
cd $CURDIR

echo "building autoconf"
set_prefix "building autoconf"
cd $SRC_DIR
if [ ! -d autoconf-$AUTOCONFVERSION ]; then
    tar xvfz $TAR_DIR/$AUTOCONFNAME
fi
cd autoconf-$AUTOCONFVERSION 
CC="ccache clang" CXX="ccache clang++" PATH=$INSTALL_DIR/local/bin:${PATH} ./configure --prefix=$INSTALL_DIR/local && make && make install
cd $CURDIR

echo "building automake"
set_prefix "building automake"
cd $SRC_DIR
if [ ! -d automake-$AUTOMAKEVERSION ]; then
    tar xvfz $TAR_DIR/$AUTOMAKENAME
fi
cd automake-$AUTOMAKEVERSION 
CC="ccache clang" CXX="ccache clang++" PATH=$INSTALL_DIR/local/bin:${PATH} ./configure --prefix=$INSTALL_DIR/local && make && make install
cd $CURDIR

echo "building ntl"
set_prefix "building ntl"
cd $SRC_DIR
if [ ! -d ntl-$NTLVERSION ]; then
    rm -rf ntl-$NTLVERSION && tar xvfz $TAR_DIR/$NTLNAME
fi
cd ntl-$NTLVERSION/src
CC="ccache clang" CXX="ccache clang++" PATH=$INSTALL_DIR/local/bin:${PATH} ./configure PREFIX=$INSTALL_DIR SHARED=on NTL_GMP_LIP=on GMP_PREFIX=$INSTALL_DIR
PATH=$INSTALL_DIR/local/bin:${PATH} make 
PATH=$INSTALL_DIR/local/bin:${PATH} make install
cd $CURDIR

echo "building singular"
set_prefix "building singular"
cd $SRC_DIR 
if [ ! -d singular/.git ]; then 
    git clone https://github.com/Singular/Sources.git singular; 
else cd singular; git pull; 
fi
cd $CURDIR
cd $SRC_DIR/singular 
PATH=$INSTALL_DIR/local/bin:${PATH} ./autogen.sh
CC="ccache clang" CXX="ccache clang++" PATH=$INSTALL_DIR/bin:${PATH} ./configure --prefix=$INSTALL_DIR --with-flint=$INSTALL_DIR --with-gmp=$INSTALL_DIR --with-mpfr=$INSTALL_DIR --with-ntl=$INSTALL_DIR --disable-gfanlib --without-dynamic-kernel --without-MP --disable-static
cd $CURDIR
cd $SRC_DIR/singular
PATH=$INSTALL_DIR/local/bin:${PATH} make && make install
cd $CURDIR

echo "building ppl"
set_prefix "building ppl"
cd $SRC_DIR
if [ ! -d ppl/.git ]; then 
    git clone git://git.cs.unipr.it/ppl/ppl.git ppl; 
else 
    cd ppl; git pull; 
fi
cd $CURDIR
cd $SRC_DIR/ppl 
PATH=$INSTALL_DIR/local/bin:${PATH} libtoolize --force
PATH=$INSTALL_DIR/local/bin:${PATH} autoreconf -fi
CC="ccache clang" CXX="ccache clang++" ./configure --prefix=$INSTALL_DIR --with-gmp=$INSTALL_DIR
$SED 's/demos doc m4/demos m4/g' Makefile > Makefile.tmp && mv Makefile.tmp Makefile
make && make install
cd $CURDIR

echo "building termreadline"
set_prefix "building termreadline"
if [[ "$MACVERSION" == "10.15" ]]; then
  CPATH_DIR=/Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk/System/Library/Perl/5.18/darwin-thread-multi-2level/CORE/
fi
cd $SRC_DIR
if [ ! -d Term-ReadLine-Gnu-$TERMRLGNUVERSION ]; then
    tar xvfz $TAR_DIR/$TERMRLGNUNAME
fi
cd Term-ReadLine-Gnu-$TERMRLGNUVERSION
CPATH=$CPATH_DIR  ARCHFLAGS='-arch x86_64' perl Makefile.PL INSTALL_BASE=$INSTALL_DIR/perl-modules --prefix=$INSTALL_DIR && make && make install
cd $CURDIR

echo "building perl modules"
set_prefix "building perl modules"
export PERL5LIB=$INSTALL_DIR/perl-modules/lib/perl5:$INSTALL_DIR/perl-modules/lib/perl5/darwin-thread-multi-2level:$INSTALL_DIR/perl-modules/lib/perl5/site_perl:$PERL5LIB
cd $SRC_DIR
if [ ! -d XML-LibXSLT-$LIBXSLTVERSION ]; then
    tar xfz $TAR_DIR/$LIBXSLTNAME
fi
cd XML-LibXSLT-$LIBXSLTVERSION 
ARCHFLAGS='-arch x86_64' perl Makefile.PL PREFIX=$INSTALL_DIR/perl-modules && make && make install
cd $CURDIR
cd $SRC_DIR
if [ ! -d SVG-$SVGVERSION ]; then
    tar xfz $TAR_DIR/$SVGNAME
fi
cd SVG-$SVGVERSION
ARCHFLAGS='-arch x86_64' perl Makefile.PL PREFIX=$INSTALL_DIR/perl-modules && make && make install
cd $CURDIR
cd $SRC_DIR
if [ ! -d Canary-Stability-$CANARYVERSION ]; then
    tar xfz $TAR_DIR/$CANARYNAME
fi
cd Canary-Stability-$CANARYVERSION
ARCHFLAGS='-arch x86_64' perl Makefile.PL PREFIX=$INSTALL_DIR/perl-modules && make && make install
cd $CURDIR
cd $SRC_DIR
if [ ! -d JSON-XS-$JSONXSVERSION ]; then
    tar xfz $TAR_DIR/$JSONXSNAME
fi
cd JSON-XS-$JSONXSVERSION
ARCHFLAGS='-arch x86_64' perl Makefile.PL PREFIX=$INSTALL_DIR/perl-modules && make && make install
cd $CURDIR
cd $SRC_DIR
if [ ! -d JSON-$JSONVERSION ]; then
    tar xfz $TAR_DIR/$JSONNAME
fi
cd JSON-$JSONVERSION
ARCHFLAGS='-arch x86_64' perl Makefile.PL PREFIX=$INSTALL_DIR/perl-modules && make && make install
cd $CURDIR

echo "installing ninja"
set_prefix "installing ninja"
cd $INSTALL_DIR/bin; 
if [[ ! -f ninja ]]; then 
    unzip $TAR_DIR/ninja-mac.zip; 
fi
export PATH=$INSTALL_DIR/bin:$PATH

export PERL5LIB=$INSTALL_DIR/perl-modules/lib/perl5/darwin-thread-multi-2level:$INSTALL_DIR/perl-modules/lib/perl5/site_perl:$PERL5LIB
if [[ ! -f $HOME/.bash_profile || ! `grep "PERL5LIB.*dependencies" $HOME/.bash_profile` ]]; then
    echo "export PERL5LIB=$INSTALL_DIR/perl-modules/lib/perl5/darwin-thread-multi-2level:$INSTALL_DIR/perl-modules/lib/perl5/site_perl:$PERL5LIB" >> $HOME/.bash_profile
fi
echo "building polymake in $POLYMAKE_SRC_DIR"
set_prefix "building polymake"  
if [ ! -d $POLYMAKE_SRC_DIR/.git ]; then 
    git clone $POLYMAKE_SERVER $POLYMAKE_SRC_DIR; 
else 
    cd $POLYMAKE_SRC_DIR; git pull; 
fi
cd $CURDIR
cd $POLYMAKE_SRC_DIR
cat > polymake_configure.$NAME <<EOF
./configure CC=clang CXX=clang++ CFLAGS="-fpic -DPIC -DLIBSINGULAR" CXXFLAGS="-fpic -DPIC -DLIBSINGULAR "\\
	--with-ant=$INSTALL_DIR/ant/bin/ant \\
	--prefix=$INSTALL_POLYMAKE_DIR \\
    --build $NAME \\
	--with-boost=$INSTALL_DIR/boost \\
	--with-gmp=$INSTALL_DIR \\
	--with-mpfr=$INSTALL_DIR \\
	--with-jni-headers=$JNIHEADERS \\
	--with-ppl=$INSTALL_DIR

#	--with-singular=$INSTALL_DIR \\

EOF

if [ -n "$CCACHE" ]; then
    echo "--with-ccache=$CCACHE_BIN" >> polymake_configure.$NAME
fi
chmod u+x polymake_configure.$NAME
./polymake_configure.$NAME
ninja -C build.$NAME/Opt install

cd $CURDIR

exec >&3 2>&4


