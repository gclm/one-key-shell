#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
install_tmp='/tmp/bt_install.pl'
public_file=/www/server/panel/install/public.sh


if [ ! -f $public_file ];then
	wget -O $public_file $miui_Url/install/public.sh -T 5;
fi
. $public_file

download_Url=$NODE_URL
miui_Url='http://download.miui.uk:25041';

Install_hm()
{
	mkdir -p /www/server/panel/plugin/hm_shell_san
	cd /www/server/panel/plugin/hm_shell_san
	echo '正在安装脚本文件...' > $install_tmp && wget $miui_Url/install/plugin/hm_shell_san/hm_shell_san.zip
	unzip hm_shell_san.zip
	rm -rf hm_shell_san.zip
	cd /usr/local/ && wget $miui_Url/install/plugin/hm_shell_san/hm-linux-amd64.tgz && tar zxf hm-linux-amd64.tgz && rm -rf /usr/local/hm-linux-amd64.tgz
	echo '安装完成' > $install_tmp
    echo -e "\033[31m脚本执行完毕，欢迎使用！ \033[0m"
	rm -rf hm_shell_san.sh
}

Uninstall_hm()
{
	rm -rf /www/server/panel/plugin/hm_shell_san
}


action=$1
if [ "${1}" == 'install' ];then
	Install_hm
else
	Uninstall_hm
fi
