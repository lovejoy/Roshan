#!/bin/sh

WORKDIR=`dirname $0`
WORKDIR=`cd "$WORKDIR"; pwd`

cd $WORKDIR

echo "extracting..."
tar xzf roshan_env_pack.tgz

cd sqlite-3.6.4
./configure --prefix=$WORKDIR/sqlite --disable-tcl && make -j4 && make install
cd ..

cd Python-2.6.5
sed s!\$sqlite_path!$WORKDIR\/sqlite!g setup.py.template > setup.py
./configure --prefix=$WORKDIR/python --enable-shared && make -j4 && make install
export LD_LIBRARY_PATH=$WORKDIR/python/lib/:$LD_LIBRARY_PATH
export PATH=$WORKDIR/python/bin:$PATH
cd ..

cd setuptools-0.6c11
python setup.py install
cd ..

easy_install ipython-0.10-py2.6.egg

cd Django-1.2.1
python setup.py install
cd ..

cd httpd-2.2.22
./configure --prefix=$WORKDIR/apache --with-python=$WORKDIR/python/bin/python --with-apxs=$WORKDIR/apache/bin/apxs --with-included-apr && make -j4 && make install
echo "LoadModule  wsgi_module modules/mod_wsgi.so" >> $WORKDIR/apache/conf/httpd.conf
echo "WSGIScriptAlias /roshan $WORKDIR/roshan/roshan.wsgi" >> $WORKDIR/apache/conf/httpd.conf 
echo "<Directory $WORKDIR/roshan>" >> $WORKDIR/apache/conf/httpd.conf 
echo "Order deny,allow" >> $WORKDIR/apache/conf/httpd.conf
echo "Allow from all" >> $WORKDIR/apache/conf/httpd.conf
echo "</Directory>" >> $WORKDIR/apache/conf/httpd.conf
cd ..

cd mod_wsgi-2.6 
./configure --prefix=$WORKDIR/apache --with-python=$WORKDIR/python/bin/python --with-apxs=$WORKDIR/apache/bin/apxs && make -j4 && make install
cd ..

rm -rf httpd-2.2.22 mod_wsgi-2.6 setuptools-0.6c11 sqlite-3.6.4 Python-2.6.5 Django-1.2.1 ipython-0.10-py2.6.egg 
