#!/usr/bin/env bash

tomcat(){
    echo "安装tomcat 之前必须安装 JDK"
    cd /usr/local/src

    echo "正在下载 tomcat 安装包，请稍等..."
    wget -N --no-check-certificate https://gclm.coding.net/p/java/d/java/git/raw/master/apache-tomcat-9.0.34.tar.gz

    echo " 开始安装 tomcat "
    tar -zxvf apache-tomcat-9.0.34.tar.gz
    mv apache-tomcat-9.0.34  /usr/local/tomcat
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
tomcat_uninstall
tomcat
}

main