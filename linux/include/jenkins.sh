#!/usr/bin/env bash

install(){
echo -e "开始安装 Jenkins"
wget  https://mirrors.huaweicloud.com/jenkins/redhat-stable/jenkins-2.222.4-1.1.noarch.rpm
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
rpm -ivh jenkins-2.222.4-1.1.noarch.rpm
}

install2(){
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum install -y jenkins
}

install

