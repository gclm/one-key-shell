#!/usr/bin/env bash

install(){
    git_shell=`command -v git`
    if [[ ${git_shell} == "/usr/local/git/bin/git" || ${git_shell} == "/usr/bin/git" ]]; then
        yum install -y epel-release
        curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.rpm.sh | bash
        yum install -y git-lfs
        echo "git lfs 安装完成"
        git lfs install
    else
        echo "请安装 git 后在进行安装 Git lfs !!!!"
		exit
    fi
}

install