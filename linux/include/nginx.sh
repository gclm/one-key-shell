#!/usr/bin/env bash


install(){

rm -rf /etc/yum.repos.d/nginx.repo
yum install -y yum-utils
sudo tee /etc/yum.repos.d/nginx.repo <<-'EOF'
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true

[nginx-mainline]
name=nginx mainline repo
baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/
gpgcheck=1
enabled=0
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
EOF

yum install -y nginx
mkdir -p /etc/nginx/snippets
wget -0 /etc/nginx/snippets/compression.conf https://gitee.com/gclm/one-key-linux/raw/master/config/nginx/snippets/compression.conf
wget -0 /etc/nginx/snippets/default.conf https://gitee.com/gclm/one-key-linux/raw/master/config/nginx/snippets/default.conf
wget -0 /etc/nginx/snippets/ssl.conf https://gitee.com/gclm/one-key-linux/raw/master/config/nginx/snippets/ssl.conf
clear
echo "Nginx 安装完成"
nginx -v
}

install