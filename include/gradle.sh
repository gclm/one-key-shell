#!/usr/bin/env bash

install(){
    cd /usr/local/src

    echo "正在下载 Gradle 安装包，请稍等..."
    wget -N --no-check-certificate https://gclm.coding.net/p/java/d/java/git/lfs/master/gradle-6.2.2-bin.zip
    echo "开始安装 Gradle "
    unzip gradle-6.2.2-bin.zip
    mv gradle-6.2.2  /usr/local/gradle

    echo "export GRADLE_HOME=/usr/local/gradle" >> /etc/profile
    echo "export PATH=\$PATH:\$GRADLE_HOME/bin:" >> /etc/profile

    source /etc/profile
    clear
    echo "Gradle 安装成功"
    gradle -v
}

uninstall(){
    echo "开始卸载原有 maven 组件"
	rm -rf /usr/local/src/gradle-*
	rm -rf /usr/local/gradle
    sed -i '/GRADLE_HOME/d' /etc/profile
    source /etc/profile
}

main(){
echo "安装Gradle 之前必须安装 JDK"
uninstall
install
}

main