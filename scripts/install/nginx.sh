#!/usr/bin/env bash

install(){

rm -rf /etc/yum.repos.d/nginx.repo
cd /etc/yum.repos.d
sudo tee /etc/yum.repos.d/nginx.repo <<-'EOF'
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/7/$basearch/
gpgcheck=0
enabled=1
EOF
yum install -y nginx
echo -e "${Blue} Nginx 安装完成 ${Font}"

}

install