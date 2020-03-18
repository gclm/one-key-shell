#!/usr/bin/env bash

# 初始化环境
yum(){
cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
wget -P /etc/yum.repos.d/ http://mirrors.aliyun.com/repo/epel-7.repo
yum clean all
yum makecache
}

install(){
# 更新 yum 组件版本
yum -y update

# 安装基础组件
yum install -y curl wget vim
yum -y groupinstall 'Development Tools'

echo "安装 curl wget vim success"
}

main(){
# 判断系统是否是centos和 root 用户
curl
# 更换镜像为阿里云镜像
yum

install


reboot

}

main