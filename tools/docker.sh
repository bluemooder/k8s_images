#!/bin/bash
#Author:运维艄公
#Blog:http://www.opstrend.cn
#Time:2019-10-14 15:59:49
#Name:docker.sh
#Version:V1.0
#Description:This is a production script.

set -e

# 此脚本用于安装docker 18.09之前版本
# 定义安装docker版本
VERSION=18.06.1.ce
# 删除旧版本docker or docker-engine
<<EOF
yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine 
EOF

# 删除旧版本docker-ce
yum remove docker-ce -y

# 删除所有旧数据
rm -rf /var/lib/docker

# 安装依赖包
yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2 

# 添加docker阿里镜像源
yum-config-manager \
    --add-repo \
    http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

# 安装docker
yum install -y docker-ce-$VERSION

# 配置镜像加速器
mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://f6ipnw91.mirror.aliyuncs.com"]
}
EOF

# 启动docker服务
systemctl start docker
systemctl enable docker