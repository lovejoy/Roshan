#!/bin/sh

WORKDIR=`dirname $0`
WORKDIR=`cd "$WORKDIR"; pwd`
export LD_LIBRARY_PATH=$WORKDIR/../python/lib:$LD_LIBRARY_PATH

: > $WORKDIR/roshan.sqlite3
$WORKDIR/../python/bin/python $WORKDIR/manage.py syncdb
