#!/usr/bin/env bash

init(){
#1. 安装依赖包
yum -y install gcc gcc-c++ bzip2 perl curl curl-devel  expat-devel gettext-devel openssl-devel  libxml2 libxml2-devel libjpeg-devel libpng-devel  freetype-devel libmcrypt-devel autoconf
#2. 配置扩展包安装源
yum -y install epel-release
yum -y install libmcrypt libmcrypt-devel mcrypt mhash
#3. 安装编译所需要的组件
cd /usr/local/src && wget https://ftp.pcre.org/pub/pcre/pcre-8.44.tar.gz && tar zxvf pcre-8.44.tar.gz && cd pcre-8.44 && ./configure --prefix=/usr/local/pcre && make && make install
cd /usr/local/src && wget http://zlib.net/zlib-1.2.11.tar.gz && tar zxvf zlib-1.2.11.tar.gz && cd zlib-1.2.11 && ./configure --prefix=/usr/local/zlib && make && make install
cd /usr/local/src && wget https://github.com/jemalloc/jemalloc/releases/download/5.2.1/jemalloc-5.2.1.tar.bz2 && tar xvf jemalloc-5.2.1.tar.bz2 && cd jemalloc-5.2.1 && ./configure --prefix=/usr/local/jemalloc && make && make install
cd /usr/local/src && wget https://www.openssl.org/source/openssl-1.1.1d.tar.gz && tar zxvf openssl-1.1.1d.tar.gz && cd openssl-1.1.1d && ./config --prefix=/usr/local/openssl && make && make install
cd /usr/local/src && git clone https://gitee.com/gclm/ngx_brotli.git
rm -rf pcre-8.44.tar.gz
rm -rf zlib-1.2.11.tar.gz
rm -rf jemalloc-5.2.1.tar.bz2
rm -rf openssl-1.1.1d.tar.gz
}

install_nginx(){
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

install_tengine(){
# 1. 下载
cd /usr/local/src && wget https://tengine.taobao.org/download/tengine-2.3.2.tar.gz && tar -zxvf tengine-2.3.2.tar.gz && cd tengine-2.3.2
# 2. 编译安装
 ./configure --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib64/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=www --group=www --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module \
--with-pcre=/usr/local/src/pcre-8.44 \
--with-openssl=/usr/local/src/openssl-1.1.1d \
--with-jemalloc=/usr/local/src/jemalloc-5.2.1 \
--with-zlib=/usr/local/src/zlib-1.2.11 \
--add-module=./modules/ngx_http_concat_module \
--add-module=/usr/local/src/ngx_brotli

# 3. make && make install
make && make install
ln -sf /usr/sbin/nginx /usr/bin/nginx
}

main(){
# 初始化环境,安装依赖库
init
# 安装 nginx
install_nginx
# 安装 tengine
install_tengine

systemctl status nginx.service
echo "=====================================\
开机自启： systemctl enable  nginx.service
启动服务： systemctl start   nginx.service
查看服务： systemctl status  nginx.service
暂停服务： systemctl stop  nginx.service
=====================================
"
}

main