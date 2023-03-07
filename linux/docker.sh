yum remove -y docker docker-common docker-selinux docker-engine
yum install -y yum-utils device-mapper-persistent-data lvm2
wget -O /etc/yum.repos.d/docker-ce.repo https://repo.huaweicloud.com/docker-ce/linux/centos/docker-ce.repo
yum makecache fast
yum install -y docker-ce
kill -TERM 1
