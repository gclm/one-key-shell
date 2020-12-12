#!/bin/bash

centos_version="$1"

# 更换镜像为华为云 centos
echo "==> 更换镜像为华为云"
cp -a /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
wget -O /etc/yum.repos.d/CentOS-Base.repo https://repo.huaweicloud.com/repository/conf/CentOS-"$centos_version"-reg.repo
dnf -y clean all
dnf -y update

# 更换终端名
hostname="centos$centos_version"
echo "==> 修改hostname为$hostname"
hostnamectl set-hostname "$hostname"
hostnamectl --pretty
hostnamectl --static
hostnamectl --transient

# 安装基础组件
echo "==> 安装基础组件"
dnf install -y curl wget vim

# 增加github hosts
echo "==> 增加github hosts"
cat>/etc/hosts<<EOF
# 代理
151.101.0.133 raw.githubusercontent.com
199.232.68.133 raw.githubusercontent.com
199.232.68.133 user-images.githubusercontent.com
199.232.68.133 avatars2.githubusercontent.com
199.232.68.133 avatars1.githubusercontent.com
EOF

# 配置交换分区
echo "==> 修改之前交换分区"
swapon -s
free -m
echo "==> 开始配置交换分区"
fallocate -l 2G /swap
chmod 600 /swap
mkswap /swap
swapon /swap
echo "/swap   swap    swap    sw  0   0" >> /etc/fstab
echo "==> 修改之后交换分区"
swapon -s
free -m


