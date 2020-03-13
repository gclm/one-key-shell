#!/usr/bin/env bash

init(){
    # 初始化安装目录
    if [ ! -d "$java_Path" ]; then
        mkdir -p $java_Path
        echo -e "创建$java_Path目录创建成功"
    fi
}

jdk(){

    uninstall
    init

    cd $soft_path

    jdk_file=$(ls | grep jdk-*-linux-*.gz)
    jdk_dirname="jdk1.8.0_${jdk_version}"

    if [ ! -f "$jdk_file" ]; then
        echo -e "${Info}: 正在下载jdk请稍等..."
        wget -N --no-check-certificate ${coding}/jdk/jdk-8u${jdk_version}-linux-x64.tar.gz
    fi

    echo -e "${Info}: 开始安装JDK"
    tar -zxvf jdk-8u${jdk_version}-linux-x64.tar.gz -C $java_Path

    echo -e "${Info}: 配置环境变量"
    echo -e "export JAVA_HOME=$java_Path/$jdk_dirname" >> /etc/profile
    echo -e "export CLASSPATH=.:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar" >> /etc/profile
    echo -e "export PATH=\$PATH:\$JAVA_HOME/bin:" >> /etc/profile

    source /etc/profile
    echo -e "${Info}: 测试是否安装成功"
    java -version
}

# open_jdk
open_jdk(){

    uninstall

    echo -e "${Info}: 开始安装 Open JDK"
    if [[ "${release}" == "centos" ]]; then
        yum -y install  java-1.8.0-openjdk-headless java-1.8.0-openjdk java-1.8.0-openjdk-devel
    elif [[ "${release}" = "ubuntu" || "${release}" = "debian" ]];then
        apt-get -y install openjdk-8-jre openjdk-8-jdk
    fi

    source /etc/profile
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
