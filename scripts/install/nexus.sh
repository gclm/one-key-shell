#!/usr/bin/env bash


#================== nexus =============================

nexus(){

    # 初始化安装目录
    if [ ! -d "$nexus_path" ]; then
        echo -e "正在创建$nexus_path"
        mkdir -p $nexus_path
        echo -e "目录$nexus_path"
    fi

    # 增加新用户
    echo -e "${Info}:创建用户/用户组 nexus 并授权"
    groupadd nexus
    useradd -g nexus nexus
    chown -R nexus:nexus /usr/local/nexus

    cd $module_path

    nexus_file=$(ls | grep nexus-*-unix.tar.gz)
    nexus_dirname="nexus-${nexus_version}"

    if [ ! -f "$nexus_file" ]; then
        echo -e "${Info}:正在下载 nexus 请稍等..."
        wget -N --no-check-certificate ${coding}/nexus/nexus-${nexus_version}-unix.tar.gz
    fi

    tar zxvf nexus-${nexus_version}-unix.tar.gz -C $nexus_path
    mv $nexus_path/sonatype-work /opt

    echo -e "${Info}:配置环境变量"
    echo -e "export NEXUS_HOME=$nexus_path/$nexus_dirname" >> /etc/profile
    echo -e "export PATH=\$PATH:\$NEXUS_HOME/bin:" >> /etc/profile

    source /etc/profile

    echo -e "${Info}:修改配置"
    echo "run_as_user=\"nexus\"" > $nexus_path/$nexus_dirname/bin/nexus.rc
    # 仓库目录(可选)
    sed -i 's/-Dkaraf.data=..\/sonatype-work\/nexus3/-Dkaraf.data=/opt/sonatype-work/g'  $nexus_path/$nexus_dirname/bin/nexus.vmoptions
    # Java启动环境变量(必须要具体地址，不能用变量)
    sed -i 's/# INSTALL4J_JAVA_HOME_OVERRIDE=/INSTALL4J_JAVA_HOME_OVERRIDE=/usr/local/java/jdk1.8.0_241/g' $nexus_path/$nexus_dirname/bin/nexus

    echo -e "${Info}:创建开机启动项"
    ln -sf /usr/local/Nexus/bin/nexus /etc/init.d/nexus
    chkconfig --add nexus
    chkconfig nexus on

    echo -e "${Info}:启动"
    # 启动
    service nexus start
    #  调试输出
    # service nexus run
}

nexus