#!/bin/bash

#fonts color
Red="\033[31m"
Font="\033[0m"
Blue="\033[36m"


# 采用 root 权限使用该脚本
root(){
    if [[ $EUID -ne 0 ]]; then
        echo "${Red}Error:请使用root运行该脚本！"${Font} 1>&2
        exit 1
    fi
}

# 获取当前系统版本
system(){
    if [ -f /etc/redhat-release ]; then
        release="centos"
    elif cat /etc/issue | grep -Eqi "debian"; then
        release="debian"
    elif cat /etc/issue | grep -Eqi "ubuntu"; then
        release="ubuntu"
    elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
        release="centos"
    elif cat /proc/version | grep -Eqi "debian"; then
        release="debian"
    elif cat /proc/version | grep -Eqi "ubuntu"; then
        release="ubuntu"
    elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
        release="centos"
    fi
}

# 判断当前系统是否符合要求
version(){
	if [[ -s /etc/redhat-release ]]; then
	 version=`cat /etc/redhat-release|sed -r 's/.* ([0-9]+)\..*/\1/'`
	else
	 version=`grep -oE  "[0-9.]+" /etc/issue | cut -d . -f 1`
	fi
	bit=`uname -m`
	if [[ ${bit} = "x86_64" ]]; then
		bit="64"
	else
		bit="32"
	fi
}

before(){
    if [[ "${release}" = "centos" ]];then
        yum install -y curl wget
    elif [[ "${release}" = "ubuntu" || "${release}" = "debian" ]];then
        apt-get install -y curl wget
    fi
    rm -rf /opt/dev_tools
    mkdir  /opt/dev_tools
    cd /opt/dev_tools
    wget https://dev.tencent.com/u/gclm/p/shell/git/raw/master/java/jdk-8u181-linux-x64.tar.gz
    wget https://dev.tencent.com/u/gclm/p/shell/git/raw/master/java/apache-tomcat-8.5.40.tar.gz
    wget https://dev.tencent.com/u/gclm/p/shell/git/raw/master/java/apache-maven-3.6.1-bin.tar.gz
    # 解压
    tar zxvf jdk-8u181-linux-x64.tar.gz
    tar zxvf apache-tomcat-8.5.40.tar.gz
    tar zxvf apache-maven-3.6.1-bin.tar.gz
}

openjdk(){
    yum install java-1.8.0-openjdk-headless java-1.8.0-openjdk java-1.8.0-openjdk-devel -y
}

java(){
    echo "修改环境变量"
    # 复制
    cp /etc/profile /etc/profile.gclm
    # 写入文本
cat>>/etc/profile<<EOF
export JAVA_HOME=/opt/dev_tools/jdk1.8.0_181
export M2_HOME=/opt/dev_tools/apache-maven-3.6.1
export CLASSPATH=.:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar
export PATH=\$PATH:\$JAVA_HOME/bin:\$M2_HOME/bin:
EOF
    # 刷新配置
    source /etc/profile
}

uninstall_java(){
    rm -rf /opt/dev_tools
    rm -rf /etc/profile
    cp /etc/profile.gclm /etc/profile
}

#start menu
main(){
    root
    system
    version
    clear
    echo -e "———————————————————————————————————————"
    echo -e "${Blue} 孤城落寞 Java 环境 一键脚本 for Centos && Debain && Ubuntu ${Font}"
    echo -e "${Blue}当前系统: ${release} 版本: ${version} 位数:${bit} ${Font}"
    echo -e "${Blue}1、一键安装 Java8 环境  ${Font}"
    echo -e "${Blue}2、一键卸载 Java 环境 ${Font}"
    echo -e "${Blue}3、查看环境变量 ${Font}"
    echo -e "${Blue}0、退出脚本${Font}"
    echo -e "———————————————————————————————————————"
    read -p "输入数字以选择 :" num
    case "$num" in
        1)
            # uninstall_java
            before
            java
            sleep 2s
            main
        ;;
        2)
            uninstall_java
            sleep 2s
            main
        ;;
        3)
            cat /etc/profile
            sleep 2s
            main
        ;;
        0)
            cd /root
            rm -rf java.sh
            exit 1
        ;;
        *)
        clear
        echo -e "${Red} 无效输入，请重新选择 ${Font}"
        sleep 2s
        main
        ;;
        esac
}

main

