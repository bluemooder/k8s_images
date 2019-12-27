
#!/bin/bash
#Author:运维艄公
#Blog:http://www.opstrend.cn
#Time:2019-08-21 15:02:25
#Name:redis.sh
#Version:V1.0
#Description:redis初始安装

set -e

#预定义变量
export WORK_DIR=/usr/local/src
export REDIS_VERSION=5.0.2
export REDIS_DIR=/opt/redis
export REDIS_PWD=123456

#创建redis工作目录
mkdir ${REDIS_DIR}

#下载redis
cd $WORK_DIR
wget http://download.redis.io/releases/redis-${REDIS_VERSION}.tar.gz

#解压redis
tar zxvf redis-${REDIS_VERSION}.tar.gz

#编译redis
cd redis-${REDIS_VERSION}
make
make PREFIX=${REDIS_DIR} install

#拷贝redis配置文件到安装目录
mkdir ${REDIS_DIR}/{etc,data,logs}

#修改redis配置文件
sed -i "s@daemonize no@daemonize yes@" redis.conf
sed -i "s@^bind 127.0.0.1@bind 0.0.0.0@" redis.conf
sed -i "/requirepass foobared/a\requirepass ${REDIS_PWD}" redis.conf
sed -i "s@dir .@dir ${REDIS_DIR}/data@" redis.conf
sed -i "s@logfile \"\"@logfile ${REDIS_DIR}/logs/redis.log@" redis.conf


cp redis.conf  ${REDIS_DIR}/etc

#编写systemctl配置文件
cat > /usr/lib/systemd/system/redis.service <<EOF
[Unit]
Description=redis
After=network.target

[Service]
Type=forking
ExecStart=${REDIS_DIR}/bin/redis-server ${REDIS_DIR}/etc/redis.conf
ExecStop=${REDIS_DIR}/bin/redis-cli -h 127.0.0.1 -p 6379 -a '${REDIS_PWD}' shutdown
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

#启动服务
systemctl daemon-reload
systemctl enable redis.service
systemctl start redis.service
