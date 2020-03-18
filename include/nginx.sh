#!/usr/bin/env bash


install(){

shell_file=$(ls | grep system.sh)
if [ ! -f "$shell_file" ]; then
    wget https://gitee.com/gclm/one-key-linux/raw/master/include/system.sh && chmod +x system.sh
fi
. system.sh

rm -rf /etc/yum.repos.d/nginx.repo
cd /etc/yum.repos.d
sudo tee /etc/yum.repos.d/nginx.repo <<-'EOF'
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/${version}/$basearch/
gpgcheck=0
enabled=1
EOF
yum install -y nginx
echo -e "${Blue} Nginx 安装完成 ${Font}"

}

install