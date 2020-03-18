#!/usr/bin/env bash

main(){
# 判断系统是否是centos和 root 用户
curl https://gitee.com/gclm/one-key-linux/raw/master/include/system.sh | bash

yum install -y curl wget vim
echo "安装 curl wget vim success"

# 修改DNS  vi /etc/resolv.conf
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
echo "nameserver 114.114.114.114" >> /etc/resolv.conf

# 更换镜像为阿里云镜像
cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
wget -O /etc/yum.repos.d/epel-7.repo  http://mirrors.aliyun.com/repo/epel-7.repo
sed -i 's#http://mirrors.cloud.aliyuncs.com#http://mirrors.aliyun.com#g' /etc/yum.repos.d/CentOS-Base.repo
sed -i 's#http://mirrors.cloud.aliyuncs.com#http://mirrors.aliyun.com#g' /etc/yum.repos.d/epel-7.repo
yum clean all
yum makecache

# 更新 yum 组件版本
yum -y update

yum -y groupinstall 'Development Tools'

# 修改控制台
curl https://gitee.com/gclm/one-key-linux/raw/master/include/update-hostname.sh | bash

# 增加交换2G交换分区
curl https://gitee.com/gclm/one-key-linux/raw/master/include/swap.sh | bash

reboot

}

main