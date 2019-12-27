#!/bin/bash
#Author:运维艄公
#Blog:http://www.opstrend.cn
#Time:2019-08-21 09:48:35
#Name:nginx.sh
#Version:V1.0
#Description:Nginx 编译安装脚本

set -e

#预定义变量
export WORK_DIR=/usr/local/src
export NGINX_VERSION=${1:-"1.16.1"}
export NGINX_DIR=/usr/local/nginx

#安装编译nginx依赖
yum -y install gcc gcc-c++ make automake autoconf pcre pcre-devel zlib zlib-devel openssl openssl-devel libtool

#创建nginx用户
useradd nginx -s /sbin/nologin -M

#下载nginx
cd $WORK_DIR
wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz

#解压nginx
tar zxvf nginx-${NGINX_VERSION}.tar.gz

#编译nginx
cd nginx-${NGINX_VERSION}
./configure --prefix=${NGINX_DIR} --with-http_ssl_module --with-stream --user=nginx --group=nginx
make && make install

#编写systemctl配置文件
cat > /usr/lib/systemd/system/nginx.service <<EOF
[Unit]
Description=nginx - high performance web server
After=network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
ExecStart=${NGINX_DIR}/sbin/nginx
ExecReload=${NGINX_DIR}/sbin/nginx -s reload
ExecStop=${NGINX_DIR}/sbin/nginx -s stop

[Install]
WantedBy=multi-user.target
EOF

#启动服务
systemctl daemon-reload
systemctl enable nginx.service
systemctl start nginx.service





