#!/usr/bin/env bash

maven(){
    echo "安装maven 之前必须安装 JDK"
    cd /usr/local/src

    echo "正在下载 Maven 安装包，请稍等..."
    wget -N --no-check-certificate https://gclm.coding.net/p/java/d/java/git/raw/master/apache-maven-3.6.3-bin.tar.gz

    echo " 开始安装 Maven "
    tar -zxvf apache-maven-3.6.3-bin.tar.gz -C /usr/local/maven

    echo "配置环境变量"
    echo "export M2_HOME=/usr/local/maven" >> /etc/profile
    echo "export PATH=\$PATH:\$M2_HOME/bin:" >> /etc/profile
    source /etc/profile
    rm -rf /usr/local/src/apache-maven-*
    echo "安装完成"
    mvn -v
}

maven_uninstall(){
    echo "开始卸载原有 maven 组件"
    rm -rf /usr/local/src/apache-maven-*
	rm -rf /usr/local/maven
    sed -i '/M2_HOME/d' /etc/profile
    source /etc/profile
}

main(){
maven_uninstall
maven
}

main