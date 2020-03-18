#!/usr/bin/env bash

install(){

wget https://gclm.coding.net/p/yum/d/yum/git/raw/master/mwget_0.1.0.orig.tar.bz2
tar -xjvf mwget_0.1.0.orig.tar.bz2
cd mwget_0.1.0.orig
./configure --prefix=/usr/local/mwget
yum install intltool -y
make && make install

}

install