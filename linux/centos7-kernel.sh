echo "安装elrepo库"
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
yum install -y https://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm

echo "切换elrepo为清华镜像"
cp /etc/yum.repos.d/elrepo.repo /etc/yum.repos.d/elrepo.repo.bak
wget -O /etc/yum.repos.d/elrepo.repo  https://cdn.staticaly.com/gh/gclm/one-key-shell/master/linux/config/elrepo.repo
yum makecache

echo "安装 LT 版本"
yum --enablerepo=elrepo-kernel install kernel-lt-devel kernel-lt -y
grub2-set-default 0
echo "查看grub2顺序"
awk -F\' '$1=="menuentry " {print $2}' /etc/grub2.cfg
