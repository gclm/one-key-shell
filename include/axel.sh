#!/usr/bin/env bash

main(){

    echo -e "初始化axel 安装目录"
    mkdir -p $base_path/axel
    mdkir -p $module_path/axel

    #下载源码包
    wget -O axel-${axel_verson}.tar.gz ${coding}/axel/axel-${axel_verson}.tar.gz
    #解压
    tar xzvf axel-${axel_verson}.tar.gz
    #进入目录
    cd axel-${axel_verson}/
    #检查编译
    ./configure --prefix=$base_path/axel
    make && make install
    #axel 执行路径
    echo 'PATH=/usr/local/axel/bin:$PATH' > /etc/profile.d/axel.sh
    #使文件生效
    source /etc/profile
}

main