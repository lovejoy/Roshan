#!/bin/sh

WORKDIR=`dirname $0`
WORKDIR=`cd "$WORKDIR"; pwd`
export PATH=$WORKDIR/python/bin:$PATH
export LD_LIBRARY_PATH=$WORKDIR/python/lib:$LD_LIBRARY_PATH

$WORKDIR/apache/bin/apachectl $@

