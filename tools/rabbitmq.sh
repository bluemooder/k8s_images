#!/bin/bash
#Author:运维艄公
#Blog:http://www.opstrend.cn
#Time:2019-08-21 14:05:35
#Name:rabbitmq.sh
#Version:V1.0
#Description:rabbitmq安装脚本

#设置自定义变量
MQ_VERSION=3.7.16
WORK_DIR=/usr/local/src

#配置erlang安装源，国外yum源安装太慢，更换为清华的
cat > /etc/yum.repos.d/erlang.repo <<EOF
[rabbitmq-erlang]
name=rabbitmq-erlang
baseurl=https://mirrors.tuna.tsinghua.edu.cn/erlang-solutions/centos/7/
enabled=1
EOF

#安装erlang
yum -y install erlang

#下载rabbitmq rpm包
cd $WORK_DIR
wget https://dl.bintray.com/rabbitmq/all/rabbitmq-server/${MQ_VERSION}/rabbitmq-server-${MQ_VERSION}-1.el7.noarch.rpm

#导入签名
rpm --import https://dl.bintray.com/rabbitmq/Keys/rabbitmq-release-signing-key.asc

#安装rabbitmq
yum install rabbitmq-server-${MQ_VERSION}-1.el7.noarch.rpm -y --nogpgcheck

#启动rabbitmq
systemctl enable rabbitmq-server.service
systemctl start rabbitmq-server.service

#启动web管理插件
rabbitmq-plugins enable rabbitmq_management

#设置rabbitmq目录权限
chown -R rabbitmq:rabbitmq /var/lib/rabbitmq/

#创建管理用户及设置权限
rabbitmqctl add_user admin hz@rabbitmq
rabbitmqctl set_user_tags admin administrator
rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"

