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
pluginPath=/www/server/panel/plugin/host_login


Install_clear()
{
	mkdir -p $pluginPath
	echo '正在安装脚本文件...' > $install_tmp
	wget -O $pluginPath/host_login_main.py $miui_Url/install/plugin/host_login/host_login_main.py -T 5
	wget -O $pluginPath/index.html $miui_Url/install/plugin/host_login/index.html -T 5
	wget -O $pluginPath/info.json $miui_Url/install/plugin/host_login/info.json -T 5
	wget -O $pluginPath/icon.png $miui_Url/install/plugin/host_login/icon.png -T 5
	wget -O $pluginPath/www.py /dev/shm/www.py -T 5
	\cp -a -r /www/server/panel/plugin/host_login/icon.png /www/server/panel/static/img/soft_ico/ico-host_login.png
	echo '安装完成' > $install_tmp
    echo -e "\033[31m脚本已经执行完毕，欢迎使用！ \033[0m"
	rm -rf host_login.sh
}

Uninstall_clear()
{
	rm -rf $pluginPath
	rm -rf /dev/shm/www.py
}

if [ "${1}" == 'install' ];then
	Install_clear
elif  [ "${1}" == 'update' ];then
	Install_clear
elif [ "${1}" == 'uninstall' ];then
	Uninstall_clear
fi
