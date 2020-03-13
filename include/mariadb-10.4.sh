#!/usr/bin/env bash

# 安装 mariadb 10.4 二进制安装成功
Install_MariaDB104(){
# 安装 mariadb.repo
cat > /etc/yum.repos.d/mariadb.repo << EOF
# MariaDB 10.4 CentOS repository list - created 2020-02-17 06:03 UTC
# http://downloads.mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.4/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF

# 更换 mariadb 为国内源（建议使用 HTTPS）
sed -i 's#yum\.mariadb\.org#mirrors.ustc.edu.cn/mariadb/yum#' /etc/yum.repos.d/mariadb.repo
sed -i 's#http://mirrors\.ustc\.edu\.cn#https://mirrors.ustc.edu.cn#g' /etc/yum.repos.d/mariadb.repo

# 安装 mariadb
yum install MariaDB-server MariaDB-client -y

# https://blog.csdn.net/zhezhebie/article/details/73549741
# https://mirrors.ustc.edu.cn/help/mariadb.html
}