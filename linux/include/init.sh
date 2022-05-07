#!/usr/bin/env bash

# 判断系统是否是centos和 root 用户
main(){

    # 更新 yum 组件版本
    yum -y update
    yum -y groupinstall 'Development Tools'

    yum install -y curl wget vim
    echo "安装 curl wget vim success"

    # 修改控制台
    curl https://gitee.com/gclm/one-key-linux/raw/master/include/update-hostname.sh | bash

    # 增加交换2G交换分区
    curl https://gitee.com/gclm/one-key-linux/raw/master/include/swap.sh | bash
    rm -rf system.sh
    reboot

}

main