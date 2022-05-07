#!/usr/bin/env bash

install(){
    yum -y install  java-1.8.0-openjdk-headless java-1.8.0-openjdk java-1.8.0-openjdk-devel
    echo "Open JDK 安装成功"
    java -version
}

uninstall(){
	yum remove -y java-1.8.0-openjdk-headless java-1.8.0-openjdk java-1.8.0-openjdk-devel
	rm -rf /usr/local/src/jdk*
	rm -rf /usr/local/jdk
    # 判断是否有需要删除的字符串
    if [ sed -n '/JAVA_HOME/p' /etc/profile ]; then
        sed -i '/JAVA_HOME/d' /etc/profile
        source /etc/profile
    fi
    echo "卸载原有JDK完成"
}

main(){

 # 卸载原先 jdk 环境
 uninstall

 # 安装 jdk 环境
 install
}

main