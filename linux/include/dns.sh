#!/usr/bin/env bash


main(){
    # 修改DNS  vi /etc/resolv.conf
    echo "nameserver 8.8.8.8" >> /etc/resolv.conf
    echo "nameserver 114.114.114.114" >> /etc/resolv.conf
}
main