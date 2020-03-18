#!/bin/bash

# 初始化当前环境，安装必要依赖
init(){
    echo "初始化环境完成"
    yum -y install gcc gcc-c++ make libtool zlib zlib-devel openssl openssl-devel pcre pcre-devel curl-devel expat-devel gettext-devel perl-ExtUtils-MakeMaker 
}

# 卸载git
uninstall(){
    echo "卸载原先git"
	yum remove -y git
    rm -rf /usr/local/src/git-*
	rm -rf /usr/local/git
}

# 安装 git
install(){
    cd /usr/local/src
	wget https://gclm.coding.net/p/yum/d/yum/git/raw/master/git-2.25.1.tar.gz
	tar zxvf git-2.25.1.tar.gz
	cd git-2.25.1
	./configure --prefix=/usr/local/git
	make && make install
	# -f, --force remove existing destination files
    ln -sf /usr/local/git/bin/* /usr/bin/
    echo "export PATH=/usr/local/git/bin:$PATH" >> /etc/profile
    source /etc/profile
    git_version=`git --version`
    if [[ ${git_version} != "git version 2.25.1" ]]; then
        echo "Git 安装失败。"
    else
        rm -rf /usr/local/src/git-*
        echo "git 安装完成"
        git --version
    fi
}

#start menu
main(){
init
uninstall
install
}

main



