#!/usr/bin/env bash

main(){
cd /usr/local/src
#下载源码包
wget -O axel-2.17.7.tar.gz https://gclm.coding.net/p/yum/d/yum/git/raw/master/axel-2.17.7.tar.gz
#解压
tar xzvf axel-2.17.7.tar.gz
#进入目录
cd axel-2.17.7
#检查编译
./configure --prefix=/usr/local/axel
make && make install
#axel 执行路径
echo 'PATH=/usr/local/axel/bin:$PATH' > /etc/profile.d/axel.sh
#使文件生效
source /etc/profile
}

main