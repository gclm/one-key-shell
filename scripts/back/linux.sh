#!/bin/bash

#=================================================
#	System Required: CentOS 7,Debian 8/9,Ubuntu 16+
#	Description: 开发环境搭建脚本 for linux 
#	Version: 1.0.0
#	Author:  孤城落寞
#	Blog: https://blog.gclmit.club/
#=================================================

#==================基础配置 start ============================

# 字体样式
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"

# 安装路径
base_path="/usr/local"
java_Path="$base_path/java"
git_path="$base_path/git"
nexus_path="$base_path/nexus"
soft_path="/opt/software"
module_path="/opt/module"

# 版本
shell_version="0.0.4"
maven_version="3.6.2"
jdk_version="221"
tomcat_version="9.0.19"
gradle_version=""
nexus_version="3.19.1-01"
mysql_version=""
git_version="2.9.5"

# 远程安装包地址
coding="https://dev.tencent.com/u/gclm/p/resources/git/raw/master"

#==================基础配置 end =============================


#############系统开发环境组件 start #############

java(){

    init

    # 初始化安装目录
    if [ ! -d "$java_Path" ]; then
        echo -e "正在创建$java_Path目录"
        mkdir -p $java_Path
        echo -e "目录$java_Path创建成功"
    fi
}

compile(){
    echo -e "${Info}:安装开发工具---> Development Tools"
    yum -y groupinstall 'Development Tools'
    echo -e "${Info}:安装系统编译组件 ---> gcc gcc-c++ make libtool zlib zlib-devel openssl openssl-devel pcre pcre-devel curl-devel expat-devel gettext-devel perl-ExtUtils-MakeMaker"
    yum -y install gcc gcc-c++ make libtool zlib zlib-devel openssl openssl-devel pcre pcre-devel curl-devel expat-devel gettext-devel perl-ExtUtils-MakeMaker
}

#================== MySQL =============================
mysql(){
    init 

    mysql_uninstall

}

mysql_uninstall(){
    echo -e "${Info}:开始卸载mysql"
    dpkg --list | grep mysql
    sudo apt-get -y  remove mysql-common
    sudo apt-get -y autoremove --purge mysql-server-5.7
    dpkg -l | grep ^rc | awk '{print$2}' | sudo xargs dpkg -P
    dpkg --list | grep mysql
    sudo apt-get -y autoremove --purge mysql-apt-config
}

#================== jenkins =============================

jenkins(){
    echo -e "${Info}: 开始安装 Jenkins"
    wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
    yum install -y jenkins
}

#================== nexus =============================

nexus(){

    init

    # 初始化安装目录
    if [ ! -d "$nexus_path" ]; then
        echo -e "正在创建$nexus_path"
        mkdir -p $nexus_path
        echo -e "目录$nexus_path"
    fi

    # 增加新用户
    echo -e "${Info}:创建用户/用户组 nexus 并授权"
    groupadd nexus
    useradd -g nexus nexus
    chown -R nexus:nexus /usr/local/nexus

    cd $soft_path

    nexus_file=$(ls | grep nexus-*-unix.tar.gz)
    nexus_dirname="nexus-${nexus_version}"

    if [ ! -f "$nexus_file" ]; then
        echo -e "${Info}:正在下载 nexus 请稍等..."
        wget -N --no-check-certificate ${coding}/linux/nexus/nexus-${nexus_version}-unix.tar.gz
    fi

    tar zxvf nexus-${nexus_version}-unix.tar.gz -C $nexus_path
    mv $nexus_path/sonatype-work /opt
    
    echo -e "${Info}:配置环境变量"
    echo -e "export NEXUS_HOME=$nexus_path/$nexus_dirname" >> /etc/profile
    echo -e "export PATH=\$PATH:\$NEXUS_HOME/bin:" >> /etc/profile

    source /etc/profile

    echo -e "${Info}:修改配置"
    echo "run_as_user=\"nexus\"" > $nexus_path/$nexus_dirname/bin/nexus.rc
    # 仓库目录(可选)
    sed -i 's/-Dkaraf.data=..\/sonatype-work\/nexus3/-Dkaraf.data=/opt/sonatype-work/g'  $nexus_path/$nexus_dirname/bin/nexus.vmoptions
    # Java启动环境变量(必须要具体地址，不能用变量)
    sed -i 's/# INSTALL4J_JAVA_HOME_OVERRIDE=/INSTALL4J_JAVA_HOME_OVERRIDE=/usr/local/java/jdk1.8.0_221/g' $nexus_path/$nexus_dirname/bin/nexus

    echo -e "${Info}:创建开机启动项"
    ln -sf /usr/local/Nexus/bin/nexus /etc/init.d/nexus
    chkconfig --add nexus
    chkconfig nexus on
    
    echo -e "${Info}:启动"
    # 启动
    service nexus start
    #  调试输出
    # service nexus run
}

# 安装 git
git_install(){

    init

    echo -e "${Info}: 开始安装 Git v${git_version}"

    git_uninstall

    compile

    cd $soft_path

    git_file=$(ls | grep git-*.gz)
    git_dirname="git-${git_version}"

    if [ ! -f "$git_file" ]; then
        echo -e "${Info}:正在下载git请稍等..."
        wget -N --no-check-certificate ${coding}/linux/git/git-${git_version}.tar.gz
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
#================== jdk =============================

# oracle  jdk install
jdk(){

    java

    jdk_uninstall
    
    cd $soft_path
    
    jdk_file=$(ls | grep jdk-*-linux-*.gz)
    jdk_dirname="jdk1.8.0_${jdk_version}"

    if [ ! -f "$jdk_file" ]; then
        echo -e "${Info}: 正在下载jdk请稍等..."
        wget -N --no-check-certificate ${coding}/linux/java/jdk-8u${jdk_version}-linux-x64.tar.gz
    fi

    echo -e "${Info}: 开始安装JDK"
    tar -zxvf jdk-8u${jdk_version}-linux-x64.tar.gz -C $java_Path
   
    echo -e "${Info}: 配置环境变量"
    echo -e "export JAVA_HOME=$java_Path/$jdk_dirname" >> /etc/profile
    echo -e "export CLASSPATH=.:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar" >> /etc/profile
    echo -e "export PATH=\$PATH:\$JAVA_HOME/bin:" >> /etc/profile

    source /etc/profile

    jdk_test
}

# open_jdk 
open_jdk(){

    jdk_uninstall

    echo -e "${Info}: 开始安装JDK"
    if [[ "${release}" == "centos" ]]; then
        yum -y install  java-1.8.0-openjdk-headless java-1.8.0-openjdk java-1.8.0-openjdk-devel 
    elif [[ "${release}" = "ubuntu" || "${release}" = "debian" ]];then
        apt-get -y install openjdk-8-jre openjdk-8-jdk
    fi

    jdk_test
}

jdk_test(){
    echo -e "${Info}: 测试是否安装成功"
    java -version
}

jdk_uninstall(){
    echo -e "${Info}:开始卸载原有 JDK"
	yum remove -y java-1.8.0-openjdk-headless java-1.8.0-openjdk java-1.8.0-openjdk-devel 
	rm -rf $java_Path/jdk1.8.0_${jdk_version}
    rm -rf $soft_path/jdk-8u${jdk_version}-linux-x64.tar.gz
    # 判断是否有需要删除的字符串
    if [ sed -n '/JAVA_HOME/p' /etc/profile ]; then
        sed -i '/JAVA_HOME/d' /etc/profile
        source /etc/profile
    fi
}

#================== maven =============================

# maven install
maven(){

    java

    echo -e "${Tip}安装maven 之前必须安装 JDK"
    
    maven_uninstall

    cd $soft_path
    
    maven_file=$(ls | grep apache-maven-*.gz)
    maven_dirname="apache-maven-${maven_version}"

    if [ ! -f "$maven_file" ]; then
       echo -e "${Info}:正在下载 Maven 安装包，请稍等..."
       wget -N --no-check-certificate ${coding}/linux/java/apache-maven-${maven_version}-bin.tar.gz
    fi

    echo -e "${Info}: 开始安装 Maven "
    tar -zxvf apache-maven-${maven_version}-bin.tar.gz -C $java_Path
    
    echo -e "${Info}:配置环境变量"
    echo -e "export M2_HOME=/usr/local/java/$maven_dirname" >> /etc/profile
    echo -e "export PATH=\$PATH:\$M2_HOME/bin:" >> /etc/profile
    source /etc/profile

    echo $java_path

    echo -e "${Info}:测试是否安装成功"
    mvn -v
}

maven_uninstall(){
    echo -e "${Info}:开始卸载原有 maven 组件"
	rm -rf $java_Path/apache-maven-${maven_version}
    rm -rf $soft_path/apache-maven-${maven_version}-bin.tar.gz
    sed -i '/M2_HOME/d' /etc/profile
    source /etc/profile
}

#############系统开发环境组件  end #############



#############系统基础组件  start #############

# 采用 root 权限使用该脚本
root(){
   #判断是否是roo用户
   if [ $(id -u) != "0" ]; then
        echo "Error:You must be root to run this script"
   fi
}

# 初始化环境
init(){
    # 初始化软件文件夹
    echo -e "${Info} 初始化安装软件文件夹"
    if [ ! -d "$soft_path" ]; then
        echo -e "正在创建$soft_path目录"
        mkdir -p $soft_path
        echo -e "目录$soft_path创建成功"
    fi

    if [[ "${release}" = "centos" ]];then
       init_centos
    elif [[ "${release}" = "ubuntu" || "${release}" = "debian" ]];then
       init_debain_ubuntu
    fi
}

# 基础环境组件 centos
init_centos(){ 
    echo -e "${Info}:================== 开始进行初始化环境 ============================="
    echo -e "${Info}:更新系统缓存"
    yum -y update 
    echo -e "${Info}:安装 curl wget vim"
    yum install -y curl wget vim
    echo -e "${Info}:================== 初始化环境完成 ============================="
}

# 基础环境组件 debain/ubuntu
init_debain_ubuntu(){
    echo -e "${Info}:================== 开始进行初始化环境 ============================="
    echo -e "安装更新系统缓存"
    apt-get -y update
    echo -e "安装系统编译组件 ---> gcc gcc-c++ make libtool zlib zlib-devel openssl openssl-devel pcre pcre-devel curl-devel expat-devel gettext-devel perl-ExtUtils-MakeMaker"
    apt-get -y install gcc gcc-c++ make libtool zlib zlib-devel openssl openssl-devel pcre pcre-devel curl-devel expat-devel gettext-devel perl-ExtUtils-MakeMaker 
    echo -e "安装 ---> wget"
    apt-get install -y curl wget
}


#更新脚本
Update_Shell(){
	echo -e "当前版本为 [ ${shell_version} ]，开始检测最新版本..."
	shell_new_version=$(wget --no-check-certificate -qO- "http://${coding}/linux/linux.sh"|grep 'shell_version="'|awk -F "=" '{print $NF}'|sed 's/\"//g'|head -1)
	[[ -z ${shell_new_version} ]] && echo -e "${Error} 检测最新版本失败 !" && start_menu
	if [[ ${shell_new_version} != ${shell_version} ]]; then
		echo -e "发现新版本[ ${shell_new_version} ]，是否更新？[Y/n]"
		read -p "(默认: y):" yn
		[[ -z "${yn}" ]] && yn="y"
		if [[ ${yn} == [Yy] ]]; then
			wget -N --no-check-certificate http://${github}/linux/linux.sh && chmod +x linux.sh
			echo -e "脚本已更新为最新版本[ ${shell_new_version} ] !"
		else
			echo && echo "	已取消..." && echo
		fi
	else
		echo -e "当前已是最新版本[ ${shell_new_version} ] !"
		sleep 5s
	fi
}

#开始菜单
start_menu(){
clear
echo -e "
Linux开发环境 一键安装管理脚本 ${Red_font_prefix}[v${shell_version}]${Font_color_suffix}
  -- 孤城落寞博客 | blog.gclmit.club --
  
 ${Green_font_prefix}0.${Font_color_suffix} 初始化安装环境  
———————————— 开发环境(Java) ————————————
 ${Green_font_prefix}11.${Font_color_suffix} 安装 Oracle-JDK(v8u${jdk_version})
 ${Green_font_prefix}12.${Font_color_suffix} 安装 Open-JDK(v1.8.0)
 ${Green_font_prefix}13.${Font_color_suffix} 安装 Maven(v${maven_version})
 ${Green_font_prefix}14.${Font_color_suffix} 安装 Nexus(v${nexus_version}) 
 ${Green_font_prefix}15.${Font_color_suffix} 安装 Gradle(v${gradle_version}) 
 ${Green_font_prefix}16.${Font_color_suffix} 安装 MySQL(v${mysql_version})
 ${Green_font_prefix}17.${Font_color_suffix} 安装 Tomcat(v${tomcat_version})
———————————— 运维环境 —————————————————
 ${Green_font_prefix}21.${Font_color_suffix} 安装 Git
 ${Green_font_prefix}22.${Font_color_suffix} 安装 Jenkins
 ${Green_font_prefix}23.${Font_color_suffix} 安装 Nginx
 ${Green_font_prefix}24.${Font_color_suffix} 安装 Git LFS
———————————— 杂项管理 —————————————————
 ${Green_font_prefix}1.${Font_color_suffix} 升级脚本
 ${Green_font_prefix}2.${Font_color_suffix} 退出脚本
——————————————————————————————————————" && echo

read -p " 请输入选项 :" num
case "$num" in
	0)
	init
	;;
    1)
	Update_Shell
	;;
    2)
	exit 1
	;;
	11)
	jdk
	;;
	12)
	open_jdk
	;;
	13)
	maven
	;;
	14)
	nexus
	;;
	15)
	startbbrmod
	;;
	16)
	mysql
	;;
    21)
	git_install
	;;
	22)
	jenkins
	;;
	23)
	remove_all
	;;
    24)
	git_lfs
	;;
	*)
	clear
	echo -e "${Error}:请输入正确选项："
	sleep 3s
	start_menu
	;;
esac
}
#############系统基础组件  end #############


#############系统检测组件 start #############

#检查系统
check_system_version(){
	if [[ -f /etc/redhat-release ]]; then
		release="centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
    fi
}

#检查Linux版本
check_linux_version(){
	if [[ -s /etc/redhat-release ]]; then
		version=`grep -oE  "[0-9.]+" /etc/redhat-release | cut -d . -f 1`
	else
		version=`grep -oE  "[0-9.]+" /etc/issue | cut -d . -f 1`
	fi
	bit=`uname -m`
	if [[ ${bit} = "x86_64" ]]; then
		bit="x64"
	else
		bit="x32"
	fi
}

#############系统检测组件 end #############
check_system_version
check_linux_version
[[ ${release} != "debian" ]] && [[ ${release} != "ubuntu" ]] && [[ ${release} != "centos" ]] && echo -e "${Error} 本脚本不支持当前系统 ${release} !" && exit 1
start_menu