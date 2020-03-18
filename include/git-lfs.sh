#!/usr/bin/env bash

install(){
    yum install -y epel-release
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.rpm.sh | bash
    yum install -y git-lfs
    echo "git lfs 安装完成"
    git lfs install
}

main(){
git_shell=`command -v git`
    if [[ ${git_shell} == "/usr/local/git/bin/git" || ${git_shell} == "/usr/bin/git" ]]; then
       install
    else
		echo "no exists git，是否安装 git 后在进行安装 Git lfs ？[Y/n]"
		read -p "(默认: y):" yn
		[[ -z "${yn}" ]] && yn="y"
		if [[ ${yn} == [Yy] ]]; then
			curl https://gitee.com/gclm/one-key-linux/raw/master/include/git.sh | bash
            install
		else
			echo && echo "	已取消..." && echo
		fi
        sleep 5s
    fi
}

main