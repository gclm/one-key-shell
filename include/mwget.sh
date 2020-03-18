#!/usr/bin/env bash

install(){
cd /usr/local/src
yum install -y gcc openssl-devel  intltool gcc-c++
wget https://gclm.coding.net/p/yum/d/yum/git/raw/master/mwget_0.1.0.orig.tar.bz2
tar -xjvf mwget_0.1.0.orig.tar.bz2
cd mwget_0.1.0.orig
./configure
make && make install
echo "mwget 安装成功"
mwget -v
}

install