#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: ./build_libdaemon.sh tool_chain_path install_path!"
    echo "Example: ./build_luibdaemon.sh /usr/local/arm-linux /Desktop/eric/logger/build/moxa-ia240/libdaemon"
    exit
fi

export PATH="$PATH:$1/bin"

tool_chain_path=$1
#ARCH=`echo $1 | awk -F"/" '{print (NF>1)? $NF : $1}'`

# linux architecture 
item=`ls $tool_chain_path/bin | grep gcc`
IFS=' ' read -ra ADDR <<< "$item"
item="${ADDR[0]}"
ARCH=`echo $item | sed -e 's/-gcc.*//g'`

# ======== libdaemon with static build ========

export ARCH=$ARCH
if [ "$ARCH" == "" ]; then
	export AR=ar
	export AS=as
	export LD=ld
	export RANLIB=ranlib
	export CC=gcc
	export NM=nm
	./configure --prefix=$2
else
	export AR=${ARCH}-ar
	export AS=${ARCH}-as
	export LD=${ARCH}-ld
	export RANLIB=${ARCH}-ranlib
	export CC=${ARCH}-gcc
	export NM=${ARCH}-nm
	./configure --prefix=$2 --target=${ARCH} --host=${ARCH} ac_cv_func_setpgrp_void=yes
fi

make clean
make
make install
rm $2/lib/libdaemon.so*
