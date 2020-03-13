#!/usr/bin/env bash


install(){

echo -e "${Info}: 开始安装 Jenkins"

cd $soft_path
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
mwget --file=jenkins-2.204.1-1.1.noarch.rpm  ${coding}/jenkins/jenkins-2.204.1-1.1.noarch.rpm
yum localinstall -y jenkins-2.204.1-1.1.noarch.rpm
yum install -y jenkins

}

install

