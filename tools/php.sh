#!/bin/bash
#Author:运维艄公
#Blog:http://www.opstrend.cn
#Time:2019-10-09 14:48:35
#Name:php.sh
#Version:V1.0
#Description:PHP 编译安装脚本

set -e
echo -e "\033[1m \033[31m#预定义变量\033[0m"
export WORK_DIR=/usr/local/src
export PHP_VERSION=7.2.23
export PHP_DIR=/usr/local/php7

echo -e "\033[1m \033[31m#安装编译PHP依赖\033[0m"
yum -y install libxml2 libxml2-devel openssl openssl-devel bzip2 bzip2-devel \
               libcurl libcurl-devel libjpeg libjpeg-devel libpng libpng-devel \
               freetype freetype-devel gmp gmp-devel libmcrypt libmcrypt-devel \
               readline readline-devel libxslt libxslt-devel gd gd-devel autoconf
#创建PHP用户
useradd www -s /sbin/nologin -M

#下载PHP
cd $WORK_DIR
curl -O https://www.php.net/distributions/php-${PHP_VERSION}.tar.gz

#解压PHP
tar zxvf php-${PHP_VERSION}.tar.gz

echo -e "\033[1m \033[31m#编译安装PHP\033[0m"
cd php-${PHP_VERSION}
./configure \
--prefix=${PHP_DIR} \
--with-config-file-path=${PHP_DIR}/etc \
--enable-fpm \
--with-fpm-user=www \
--with-fpm-group=www \
--enable-mysqlnd \
--with-mysqli=mysqlnd \
--with-pdo-mysql=mysqlnd \
--with-iconv-dir \
--with-zlib \
--with-freetype-dir \
--with-jpeg-dir \
--with-png-dir \
--with-gd \
--with-gexttext \
--with-openssl \
--with-mhash \
--with-xmlrpc \
--with-curl \
--with-libxml-dir=/usr/lib64 \
--enable-xml \
--enable-bcmath \
--enable-calendar \
--enable-inline-optimization \
--enable-mbstring \
--enable-zip \
--enable-exif \
--enable-opcache \
--enable-sockets

make && make install

#创建配置文件
cp php.ini-production ${PHP_DIR}/etc/php.ini
cp ${PHP_DIR}/etc/php-fpm.conf.default ${PHP_DIR}/etc/php-fpm.conf
cp ${PHP_DIR}/etc/php-fpm.d/www.conf.default ${PHP_DIR}/etc/php-fpm.d/www.conf

#修改php-fpm.conf配置文件，生成pid文件
cd ${PHP_DIR}
sed -i "s/;pid/pid/" etc/php-fpm.conf

#编写systemctl配置文件
cat > /usr/lib/systemd/system/php-fpm.service <<EOF
[Unit]
Description=The PHP FastCGI Process Manager
After=syslog.target network.target

[Service]
Type=forking
PIDFile=${PHP_DIR}/var/run/php-fpm.pid
ExecStart=${PHP_DIR}/sbin/php-fpm
ExecReload=/bin/kill -USR2 $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

#启动服务
systemctl daemon-reload
systemctl enable php-fpm.service
systemctl start php-fpm.service

#设置环境变量
#注意EOF一定要加''，这样才能保证$符号原样输出
cat > /etc/profile.d/php.sh <<'EOF'
#php environment
export PHP_HOME=/usr/local/php7
export PATH=$PHP_HOME/bin:$PATH
EOF

source /etc/profile
#检查php环境变量是否设置成功
php -v



