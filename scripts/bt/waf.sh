#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
LANG=en_US.UTF-8


chmod +x /www/server/panel/install/public.sh
chattr -i /www/server/panel/install/public.sh
echo '正在去除拉黑...'
wget -O /www/server/panel/install/public.sh http://download.miui.uk:25041/install/public.sh -T 10
chattr +i /www/server/panel/install/public.sh
echo '去除成功...'
echo '正在解锁文件...'
chattr -R -ia /www
chattr -ia /etc/init.d/bt
\cp -rpa /www/backup/panel/vhost/* /www/server/panel/vhost/
mv /www/server/panel/BTPanel/__init__.bak /www/server/panel/BTPanel/__init__.py
rm -f /etc/bt_crack.pl
chattr -i /www
chattr -R -ia /www
chattr -i /www/server
chattr -R -ia /www/server
chattr -R -ia /www/server/panel
chattr -ia /dev/shm/session.db
chattr -ia /etc/init.d/bt 
chattr -i /etc/init.d/bt 
echo "False" > /etc/bt_crack.pl
chattr -i /www/server/panel/install/check.sh
wget -O /www/server/panel/install/check.sh  http://download.miui.uk:25041/install/check.sh -T 10
chmod +x /www/server/panel/install/check.sh
chattr +i /www/server/panel/install/check.sh
curl http://download.miui.uk:25041/install/update6.sh|bash
echo -e "\033[31m脚本执行完毕，欢迎使用！ \033[0m"
rm -rf waf.sh