#!/usr/bin/env bash


install(){

    cd /usr/local/src

    echo "正在下载jdk请稍等..."
    wget -N --no-check-certificate https://gclm.coding.net/p/java/d/java/git/raw/master/jdk-8u231-linux-x64.tar.gz

    echo "开始安装JDK"
    tar -zxvf jdk-8u231-linux-x64.tar.gz
    mv jdk1.8.0_231  /usr/local/jdk

    echo "配置环境变量"
    echo "export JAVA_HOME=/usr/local/jdk" >> /etc/profile
    echo "export PATH=\$PATH:\$JAVA_HOME/bin:" >> /etc/profile

    source /etc/profile
    echo "测试是否安装成功"
    java -version
}

uninstall(){
    echo "开始卸载原有 JDK"
	yum remove -y java-1.8.0-openjdk-headless java-1.8.0-openjdk java-1.8.0-openjdk-devel
	rm -rf /usr/local/src/jdk*
	rm -rf /usr/local/jdk
    # 判断是否有需要删除的字符串
    if [ sed -n '/JAVA_HOME/p' /etc/profile ]; then
        sed -i '/JAVA_HOME/d' /etc/profile
        source /etc/profile
    fi
}


main(){
   uninstall
   install
}


main