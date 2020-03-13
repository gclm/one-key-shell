#!/usr/bin/env bash

main(){
echo "配置交换分区前情况:"
swapon -s
free -m
echo "开始配置交换分区"
fallocate -l 2G /swap
chmod 600 /swap
mkswap /swap
swapon /swap
echo "/swap   swap    swap    sw  0   0" >> /etc/fstab
echo "配置交换分区后情况:"
swapon -s
free -m
}

main