echo "删除旧版docker"
apt-get remove docker docker-engine docker.io
echo "更新docker镜像并下载docker"
apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://repo.huaweicloud.com/docker-ce/linux/debian/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://repo.huaweicloud.com/docker-ce/linux/debian $(lsb_release -cs) stable"
apt-get update -y
apt-get install -y docker-ce
echo "配置docker国内镜像源"
mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": [ 
     "https://hub-mirror.c.163.com",
     "https://mirror.baidubce.com"
   ]
}
EOF
systemctl daemon-reload
systemctl restart docker
