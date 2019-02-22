currdir=`pwd`;

# the following package must be installed prior to requesting the installation of mongodb!
echo '' | fink install md5deep
# now get the rest. 
echo '' | fink install gmp5 readline6 term-readline-gnu-pm5182 libxslt xml-libxslt-pm5182 extutils-parsexs-pm xhtml-dtd libmpfr4 boost1.63-nopython ant ninja python3 pip-py36 mongodb
. /sw/bin/init.sh

curl -L https://cpanmin.us | perl - --sudo App::cpanminus
cpanm --self-upgrade --sudo
cpanm --local-lib=~/perl5 local::lib && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
cpanm XML::LibXSLT
cpanm SVG
cpanm Moo
cpanm ZEFRAM/Module-Runtime-0.013.tar.gz
cpanm MongoDB
cpanm JSON
if [[ ! -f $HOME/.bash_profile || ! `grep "PERL5LIB.*/Users/vagrant/perl5/lib/perl5" $HOME/.bash_profile` ]]; then
   echo "export PERL5LIB=/Users/vagrant/perl5/lib/perl5${PERL5LIB+:$PERL5LIB}" > $HOME/.bash_profile
fi 

mkdir -p $HOME/bin
echo "polymake --script jupyter --ip=0.0.0.0 --port=8888 --no-browser" > $HOME/bin/polymake_jupyter
chmod u+x $HOME/bin/polymake_jupyter

cd $currdir;


