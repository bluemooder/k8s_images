#!/bin/bash
#Author:运维艄公
#Blog:http://www.opstrend.cn
#Time:2019-08-21 10:41:53
#Name:mysql.sh
#Version:V1.0
#Description:Yum安装mysql

#预定义变量
MYSQL_VERSION=5.7.24

#下载yum repo
yum localinstall https://repo.mysql.com//mysql57-community-release-el7-11.noarch.rpm

#查看mysql yum源
yum repolist enabled | grep "mysql.*-community.*"

#更换mysql yum源为清华大学
#https://mirrors.tuna.tsinghua.edu.cn/mysql/ 

#查看可安装的mysql版本
#yum list mysql-community-server --showduplicates | sort -r

#查看支持的mysql版本
#yum repolist all | grep mysql

#开启/禁止其他版本的yum源
#yum-config-manager --disable mysql80-community
#yum-config-manager --enable mysql57-community

#安装指定版本mysql
yum install mysql-community-server-${MYSQL_VERSION}

#启动mysql服务
systemctl start mysqld
systemctl enable mysqld