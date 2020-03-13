#!/bin/bash

echo "开始卸载mysql"
dpkg --list | grep mysql
sudo apt-get -y  remove mysql-common
sudo apt-get -y autoremove --purge mysql-server-5.7
dpkg -l | grep ^rc | awk '{print$2}' | sudo xargs dpkg -P
dpkg --list | grep mysql
sudo apt-get -y autoremove --purge mysql-apt-config
echo "mysql 5.7 卸载完成"