#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

#fonts color
Red="\033[31m" 
Font="\033[0m"
Blue="\033[36m"

# 官方安装
function official_install(){
	echo "开始安装 brew"
	/usr/bin/ruby  "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	echo "开始完成"
}

# 官方卸载
function official_uninstall(){
	echo "开始卸载 brew"
	/usr/bin/ruby  "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"  
	echo "卸载完成"
}


# 第三方安装
function party_install(){
	echo "开始安装 brew"
	echo "开始完成"
}

# 第三方卸载
function party_uninstall(){
	echo "开始卸载 brew"
	cd 'brew –prefix'
	brew prune
	rm 'git ls-files'
	rm -r /usr/local/Homebrew
	rm -rf .git
	rm -rf ~/Library/Caches/Homebrew
	rm -rf /usr/local/opt
	rm -rf /usr/local/Caskroom
	rm -rf /usr/local/var/homebrew
	echo "卸载完成"
}

# 更换国内源
function source_update(){
	echo "开始更换 brew 清华源"
	cd "$(brew --repo)"
	git remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git

	cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
	git remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git
	echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles' >> ~/.bash_profile
	source ~/.bash_profile
	echo "更换 brew 清华源 完成"
}

function update(){
	brew update
}

# 安装 brew cask
function cask_install(){
   echo "开始安装 brew cask"
   echo "安装完成"
}

#start menu
main(){
    clear
    echo  "———————————————————————————————————————"
    echo  "${Blue} brew 一键脚本 for 孤城落寞 ${Font}"
    echo  "${Blue}1、一键安装官方版本 brew ${Font}"
    echo  "${Blue}2、一键安装国内源版本 brew ${Font}"
    echo  "${Blue}3、一键安装 brew cask ${Font}"
    echo  "${Blue}4、一键卸载 brew（官方版本）${Font}"
    echo  "${Blue}5、一键卸载 brew（第三方版本）${Font}"
    echo  "${Blue}6、一键更换 brew 为国内源"
    echo  "${Blue}0、退出脚本${Font}"
    echo  "———————————————————————————————————————"
    read -p "输入数字以选择 :" num
    case "$num" in
        1)  
			official_uninstall
            official_install
         	source_update
         	update
        ;;
        2)  
            official_uninstall
            party_install
            source_update
         	update
        ;;
        3)
            cask_install
            update
        ;;
        4)  
			official_uninstall
        ;;
        5)
            party_uninstall
        ;;
        6)
            source_update
            update
        ;;
        0)
            exit 1
        ;;
        *)
        clear
        echo  "${Red} 无效输入，请重新选择 ${Font}"
        sleep 2s
        main
        ;;
        esac
}
main