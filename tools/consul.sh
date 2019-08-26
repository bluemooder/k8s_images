#!/bin/bash
#Author:运维艄公
#Blog:http://www.opstrend.cn
#Time:2019-08-21 13:54:00
#Name:consul.sh
#Version:V1.0
#Description:This is a production script.

#预定义变量
export WOKR_DIR=/usr/local/src
export CONSUL_VERSION=1.5.3
export CONSUL_DIR=/opt/consul

#创建consul服务目录
mkdir -p ${CONSUL_DIR}/{data,conf,logs}
#下载consul
cd ${WOKR_DIR}
wget https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip

#解压consul，并移动可执行文件到系统环境变量目录中
yum -y install unzip
unzip consul_${CONSUL_VERSION}_linux_amd64.zip
mv consul /usr/local/bin/

#创建consul配置文件
cat > ${CONSUL_DIR}/conf/server.json <<EOF
{
    "data_dir": "/opt/consul/data",
    "log_level": "INFO",
    "log_file": "/opt/consul/logs/",
    "server": true,
    "ui": true,
    "bootstrap_expect": 1,
    "bind_addr": "127.0.0.1",
    "client_addr": "0.0.0.0",
    "enable_debug": false,
    "enable_syslog": false
}
EOF

#创建consul system系统服务文件
cat > /usr/lib/systemd/system/consul.service <<EOF
[Unit]
Description=Consul

[Service]
ExecStart=/usr/local/bin/consul agent -config-dir=/opt/consul/conf
KillSignal=SIGINT
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

#启动consul服务
systemctl daemon-reload
systemctl enable consul
systemctl start cousul