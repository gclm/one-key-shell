#!/usr/bin/env bash


main(){

    shell_file=$(ls | grep system.sh)
    if [ ! -f "$shell_file" ]; then
        wget https://gitee.com/gclm/one-key-linux/raw/master/include/system.sh && chmod +x system.sh
    fi
    . system.sh

    # 更新 dns
    curl https://gitee.com/gclm/one-key-linux/raw/master/include/dns.sh | bash

    if [[ ${version} == "7"  ]]; then
        # 更换镜像为阿里云镜像
        cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
        wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
        wget -O /etc/yum.repos.d/epel-7.repo  http://mirrors.aliyun.com/repo/epel-7.repo
        sed -i 's#http://mirrors.cloud.aliyuncs.com#http://mirrors.aliyun.com#g' /etc/yum.repos.d/CentOS-Base.repo
        sed -i 's#http://mirrors.aliyuncs.com#http://mirrors.aliyun.com#g' /etc/yum.repos.d/CentOS-Base.repo
        sed -i 's#http://mirrors.cloud.aliyuncs.com#http://mirrors.aliyun.com#g' /etc/yum.repos.d/epel-7.repo
        yum clean all
        yum makecache
    fi

    rm -rf system.sh
}

main