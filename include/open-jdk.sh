#!/usr/bin/env bash

install(){
    echo -e "${Info}: 开始安装 Open JDK"
    yum -y install  java-1.8.0-openjdk-headless java-1.8.0-openjdk java-1.8.0-openjdk-devel
    echo -e "${Info}: 测试是否安装成功"
    java -version
}

uninstall(){
    echo -e "${Info}:开始卸载原有 JDK"
	yum remove -y java-1.8.0-openjdk-headless java-1.8.0-openjdk java-1.8.0-openjdk-devel
	rm -rf $java_Path/jdk1.8.0_${jdk_version}
    rm -rf $soft_path/jdk-8u${jdk_version}-linux-x64.tar.gz
    # 判断是否有需要删除的字符串
    if [ sed -n '/JAVA_HOME/p' /etc/profile ]; then
        sed -i '/JAVA_HOME/d' /etc/profile
        source /etc/profile
    fi
}

main(){

 # 卸载原先 jdk 环境
 uninstall

 # 安装 jdk 环境
 install
}

main