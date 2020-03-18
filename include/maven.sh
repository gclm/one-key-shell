#!/usr/bin/env bash

# 初始化安装目录
init(){

if [ ! -d "$java_Path" ]; then
    echo -e "正在创建$java_Path目录"
    mkdir -p $java_Path
    echo -e "目录$java_Path创建成功"
fi
}


maven(){

    init

    echo -e "${Tip}安装maven 之前必须安装 JDK"

    maven_uninstall

    cd $soft_path

    maven_file=$(ls | grep apache-maven-*.gz)
    maven_dirname="apache-maven-${maven_version}"

    if [ ! -f "$maven_file" ]; then
       echo -e "${Info}:正在下载 Maven 安装包，请稍等..."
       wget -N --no-check-certificate ${coding}/maven/apache-maven-${maven_version}-bin.tar.gz
    fi

    echo -e "${Info}: 开始安装 Maven "
    tar -zxvf apache-maven-${maven_version}-bin.tar.gz -C $java_Path

    echo -e "${Info}:配置环境变量"
    echo -e "export M2_HOME=/usr/local/java/$maven_dirname" >> /etc/profile
    echo -e "export PATH=\$PATH:\$M2_HOME/bin:" >> /etc/profile
    source /etc/profile

    echo $java_path

    echo -e "${Info}:测试是否安装成功"
    mvn -v
}

maven_uninstall(){
    echo -e "${Info}:开始卸载原有 maven 组件"
	rm -rf $java_Path/apache-maven-${maven_version}
    rm -rf $soft_path/apache-maven-${maven_version}-bin.tar.gz
    sed -i '/M2_HOME/d' /etc/profile
    source /etc/profile
}

maven