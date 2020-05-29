#!/usr/bin/env bash

#================== nexus =============================

install(){
    # 增加新用户
    echo "创建用户/用户组 nexus 并授权"
    groupadd nexus
    useradd -g nexus nexus
    chown -R nexus:nexus /usr/local/nexus

    cd /usr/local/src
    echo "正在下载 nexus 请稍等..."
    wget -N --no-check-certificate https://gclm.coding.net/p/java/d/java/git/lfs/master/nexus-3.21.1-01-unix.tar.gz

    tar zxvf nexus-3.21.1-01-unix.tar.gz
    mv nexus-3.21.1-01  /usr/local/nexus
    mv sonatype-work /opt

    echo "export NEXUS_HOME=/usr/local/nexus" >> /etc/profile
    echo "export PATH=\$PATH:\$NEXUS_HOME/bin:" >> /etc/profile

    source /etc/profile

    echo "run_as_user=\"nexus\"" > /usr/local/nexus/bin/nexus.rc
    # 仓库目录(可选)
    sed -i 's/-Dkaraf.data=..\/sonatype-work\/nexus3/-Dkaraf.data=/opt/sonatype-work/g'  /usr/local/nexus/bin/nexus.vmoptions
    # Java启动环境变量(必须要具体地址，不能用变量)
    sed -i 's/# INSTALL4J_JAVA_HOME_OVERRIDE=/INSTALL4J_JAVA_HOME_OVERRIDE=/usr/local/java/jdk1.8.0_241/g' /usr/local/nexus/bin/nexus

    echo "创建开机启动项"
    ln -sf /usr/local/Nexus/bin/nexus /etc/init.d/nexus
    chkconfig --add nexus
    chkconfig nexus on
    # 启动
    service nexus start
    rm -rf /usr/local/src/nexus-*
    rm -rf /usr/local/src/sonatype-work
    echo "安装完成\n
    启动指令：service nexus start\n
    调试输出：service nexus run\n
    "
}

install