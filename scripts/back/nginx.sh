#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# ====================================================
# Description: Nginx 一键脚本 for CentOS 7
# Author: 孤城落寞
# Site: https://blog.gclmit.club
# ====================================================

#fonts color
Red="\033[31m" 
Font="\033[0m"
Blue="\033[36m"

# 采用 root 权限使用该脚本
root(){
    if [[ $EUID -ne 0 ]]; then
        echo "${Red}Error:请使用root运行该脚本！"${Font} 1>&2
        exit 1
    fi
}

# 获取当前系统版本
system(){
    if [ -f /etc/redhat-release ]; then
        release="centos"
    elif cat /etc/issue | grep -Eqi "debian"; then
        release="debian"
    elif cat /etc/issue | grep -Eqi "ubuntu"; then
        release="ubuntu"
    elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
        release="centos"
    elif cat /proc/version | grep -Eqi "debian"; then
        release="debian"
    elif cat /proc/version | grep -Eqi "ubuntu"; then
        release="ubuntu"
    elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
        release="centos"
    fi
}

# 判断当前系统是否符合要求
version(){
	if [[ -s /etc/redhat-release ]]; then
	 version=`cat /etc/redhat-release|sed -r 's/.* ([0-9]+)\..*/\1/'`
	else
	 version=`grep -oE  "[0-9.]+" /etc/issue | cut -d . -f 1`
	fi
	bit=`uname -m`
	if [[ ${bit} = "x86_64" ]]; then
		bit="64"
	else
		bit="32"
	fi
    if [[ "${release}" = "centos" && ${version} -ge 7 ]];then
        echo -e "${Blue}当前系统为CentOS ${version}${Font} "
    else
        echo -e "${Red}脚本不支持当前系统，安装中断!${Font} "
        exit 1
    fi
	for EXE in grep cut xargs systemctl ip awk
	do
		if ! type -p ${EXE}; then
			echo -e "${Red}系统精简厉害，脚本自动退出${Font}"
			exit 1
		fi
	done
}

# 初始化当前环境，安装必要依赖
initialization(){ 
    yum -y groupinstall 'Development Tools'
    yum -y install gcc gcc-c++ make libtool zlib zlib-devel openssl openssl-devel pcre pcre-devel curl-devel expat-devel gettext-devel perl-ExtUtils-MakeMaker 
}

# 安装 git
git_install(){
    unstall_git
    mkdir -p /opt/soft/git
    # mkdir -p /opt/soft/git
    cd /opt/soft/git
	wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.9.5.tar.gz
	tar zxvf git-2.9.5.tar.gz
	cd git-2.9.5
	./configure --prefix=/usr/local/git
	make && make install
	ln -s /usr/local/git/bin/* /usr/bin/
    echo "export PATH=/usr/local/git/bin:$PATH" >> /etc/profile
    source /etc/profile
    git_version=`git --version`
    if [[ ${git_version} != "git version 2.9.5" ]]; then
        echo -e "${Red}Git 安装失败。${Font}"
    else 
        rm -rf /opt/soft/git/git-2.9.5
        echo -e "${Blue} git 安装完成 ${Font}"
    fi  
}

# 卸载git
git_uninstall(){
	yum remove git
	rm -rf /usr/local/git
	rm -rf /usr/local/git/bin/git
	rm -rf /usr/local/git/bin/git-cvsserver
	rm -rf /usr/local/git/bin/gitk
	rm -rf /usr/local/git/bin/git-receive-pack
	rm -rf /usr/local/git/bin/git-shell
	rm -rf /usr/local/git/bin/git-upload-archive
	rm -rf /usr/local/git/bin/git-upload-pack
    echo -e "${Blue} git 卸载完成 ${Font}"
}

nginx_brotli_uninstall(){
    rm -rf  /usr/local/src/libbrotli
    rm -rf  /usr/local/src/ngx_brotli
    rm -rf  /usr/local/src/nginx*
}

nginx_brotli(){
    echo -e "${Blue}开始安装 nginx 的 brotli 组件 ${Font} "
    nginx_brotli_uninstall
    cd /usr/local/src/
    git clone https://github.com/bagder/libbrotli
    cd libbrotli
    ./autogen.sh
    ./configure
    make && make install
    cd /usr/local/src
    git clone https://github.com/google/ngx_brotli
    cd ngx_brotli && git submodule update --init
    cd /usr/local/src
    wget http://nginx.org/download/nginx-1.14.2.tar.gz
    tar -xvzf nginx-1.14.2.tar.gz && rm -rf nginx-1.14.2.tar.gz
    cd /usr/local/src/nginx-1.14.2
    ./configure --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib64/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --with-cc-opt='-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -m64 -mtune=generic -fPIC' --with-ld-opt='-Wl,-z,relro -Wl,-z,now -pie' --add-module=/usr/local/src/ngx_brotli
    make && make install
}

nginx(){
rm -rf /etc/yum.repos.d/nginx.repo
cd /etc/yum.repos.d
sudo tee /etc/yum.repos.d/nginx.repo <<-'EOF'
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/7/$basearch/
gpgcheck=0
enabled=1
EOF
yum install -y nginx
echo -e "${Blue} Nginx 安装完成 ${Font}"
}

nginx2(){
cd /usr/local/src/
rm -rf nginx*
wget http://nginx.org/download/nginx-1.14.2.tar.gz
tar -xvzf nginx-1.14.2.tar.gz && rm -rf nginx-1.14.2.tar.gz
cd /usr/local/src/nginx-1.14.2
./configure --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib64/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --with-cc-opt='-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -m64 -mtune=generic -fPIC' --with-ld-opt='-Wl,-z,relro -Wl,-z,now -pie'
make && make install
}

dns(){
    yum install  -y nscd
    nscd -i hosts
}

github(){
   echo "#github 优化 " >> /etc/hosts
   echo "52.216.107.236 github-production-release-asset-2e65be.s3.amazonaws.com" >> /etc/hosts
   echo "192.30.253.112 github.com" >> /etc/hosts
   echo "151.101.76.249 global-ssl.fastly.net" >> /etc/hosts
   dns
   echo -e "${Blue} Github 优化完成 ${Font}"
}

#start menu
main(){
    root
    system
    version
    clear
    echo -e "———————————————————————————————————————"
    echo -e "${Blue} Nginx 一键脚本 for CentOS 7 ${Font}"
    echo -e "${Blue}1、使用 Yum 源 安装 Nginx ${Font}"
    echo -e "${Blue}2、编译安装 Nginx ${Font}"
    echo -e "${Blue}3、安装/升级Git${Font}"
    echo -e "${Blue}4、配置 brotli 压缩${Font}"
    echo -e "${Blue}5、卸载Git${Font}"
    echo -e "${Blue}6、优化Github 拉取速度${Font}"
    echo -e "${Blue}7、刷新 DNS ${Font}"
    echo -e "${Blue}0、退出脚本${Font}"
    echo -e "———————————————————————————————————————"
    read -p "输入数字以选择 :" num
    case "$num" in
        1)  
            initialization
            nginx
        ;;
        2)  
            initialization
            nginx2
        ;;
        3)
            initialization
            git_install
        ;;
        4)  
        #    echo -e "${Red} 正在开发中 ${Font}"

           nginx_brotli
           
        #    exit 1
        ;;
        5)
            git_uninstall
        ;;
        6)
            github
        ;;
        7)
            dns
        ;;
        0)
            exit 1
        ;;
        *)
        clear
        echo -e "${Red} 无效输入，请重新选择 ${Font}"
        sleep 2s
        main
        ;;
        esac
}

main