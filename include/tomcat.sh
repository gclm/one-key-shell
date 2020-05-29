#!/usr/bin/env bash

version=9.0.34

tomcat(){
    tomcat_uninstall
    echo "安装tomcat 之前必须安装 JDK"
    cd /usr/local/src

    echo "正在下载 tomcat 安装包，请稍等..."
    wget -N --no-check-certificate https://gclm.coding.net/p/java/d/java/git/lfs/master/apache-tomcat-${version}.tar.gz

    echo " 开始安装 tomcat "
    tar -zxvf apache-tomcat-${version}.tar.gz
    mv apache-tomcat-${version}  /usr/local/tomcat
    rm -rf /usr/local/src/apache-tomcat-*

    clear
    echo "安装完成"
    cd /usr/local/tomcat
}

tomcat_uninstall(){
    echo "开始卸载原有 maven 组件"
    rm -rf /usr/local/src/apache-tomcat-*
	  rm -rf /usr/local/tomcat
}

main(){
  version=7.0.100
  tomcat
}

main