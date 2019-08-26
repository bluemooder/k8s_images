#!/bin/bash
#Author:运维艄公
#Blog:http://www.opstrend.cn
#Time:2019-08-26 09:41:42
#Name:jdk.sh
#Version:V1.0
#Description:jdk安装脚本

#预定义变量
export WOKR_DIR=/usr/local/src
#使用华为的镜像源下载jdk安装包，速度快，而且可以自定义安装版本，免去登陆和授权确认等操作
export JAVA_URL=https://mirrors.huaweicloud.com/java/jdk/8u191-b12/jdk-8u191-linux-x64.tar.gz

#解压JAVA
cd $WOKR_DIR
wget $JAVA_URL
tar -zxvf jdk-8u191-linux-x64.tar.gz
mv jdk1.8.0_191 /usr/local/java

#设置JAVA环境变量
#注意EOF一定要加''，这样才能保证$符号原样输出
cat > /etc/profile.d/java.sh <<'EOF'
#java environment
export JAVA_HOME=/usr/local/java
export PATH=$JAVA_HOME/bin:$PATH
EOF

source /etc/profile
#检查java环境变量是否设置成功
java -version




#
