echo "删除旧版docker"
yum remove -y docker docker-common docker-selinux docker-engine
echo "更新docker镜像并下载docker"
yum install -y yum-utils device-mapper-persistent-data lvm2
wget -O /etc/yum.repos.d/docker-ce.repo https://repo.huaweicloud.com/docker-ce/linux/centos/docker-ce.repo
yum makecache fast
yum install -y docker-ce
kill -TERM 1
echo "配置docker国内镜像源"
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": [ 
     "https://hub-mirror.c.163.com",
     "https://mirror.baidubce.com"
   ]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
