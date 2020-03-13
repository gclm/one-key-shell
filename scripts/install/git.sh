#!/usr/bin/env bash


# 安装 git
git_install(){

    echo -e "${Info}: 开始安装 Git v${git_version}"

    git_uninstall

    cd $soft_path

    git_file=$(ls | grep git-*.gz)
    git_dirname="git-${git_version}"

    if [ ! -f "$git_file" ]; then
        echo -e "${Info}:正在下载git请稍等..."
        wget -N --no-check-certificate ${coding}/git/git-${git_version}.tar.gz
    fi

    tar zxvf git-${git_version}.tar.gz
    cd git-${git_version}

    echo -e "${Info}:编译安装git --> configure "
	./configure --prefix=/usr/local/git
    echo -e "${Info}:编译安装git --> make"
	make
    echo -e "${Info}:编译安装git --> make install"
    make install
    echo -e "${Info}:ln -sf /usr/local/git/bin/* /usr/bin/"
    # -f, --force remove existing destination files
    ln -sf /usr/local/git/bin/* /usr/bin/

    echo -e "${Info}:配置环境变量"
    echo "export PATH=$PATH:/usr/local/git/bin:" >> /etc/profile

    source /etc/profile

    echo -e "${Info}:测试是否安装成功"
    git --version
    git_lfs
    exit 1
}

git_lfs(){
    git_shell=`command -v git`
    if [[ ${git_shell} == "/usr/local/git/bin/git" || ${git_shell} == "/usr/bin/git" ]]; then
        git_lfs_install
    else
        echo -e "${Info}:no exists git，是否安装 git 后在进行安装 Git lfs ？[Y/n]"
		read -p "(默认: y):" yn
		[[ -z "${yn}" ]] && yn="y"
		if [[ ${yn} == [Yy] ]]; then
			git
            git_lfs_install
		else
			echo && echo "	已取消..." && echo
		fi
        sleep 5s
    fi
}

git_lfs_install(){
    echo -e "${Info}:开始安装 git lfs"
    yum install -y epel-release
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.rpm.sh | bash
    yum install -y git-lfs
    echo -e "${Info}:初始化 git lfs"
    git lfs install
}

git_uninstall(){
    echo -e "${Info}:开始卸载原有git"
	yum remove -y git
	rm -rf $git_path
    rm -rf $soft_path/git-${git_version}
    rm -rf $soft_path/git-${git_version}.tar.gz
    sed -i '/git/d' /etc/profile
}