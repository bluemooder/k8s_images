#!/bin/bash
#Author:运维艄公
#Blog:http://www.opstrend.cn
#Time:2019-08-26 13:28:58
#Name:maven.sh
#Version:V1.0
#Description:maven配置

#预定义变量
export WOKR_DIR=/usr/local/src
export MAVEN_VERSION=3.6.1

#下载maven
cd $WOKR_DIR
wget http://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz
tar -zxvf apache-maven-${MAVEN_VERSION}-bin.tar.gz
mv apache-maven-${MAVEN_VERSION} /usr/local/maven

#设置maven环境变量
#注意EOF一定要加''，这样才能保证$符号原样输出
cat > /etc/profile.d/maven.sh <<'EOF'
#maven environment
export MAVEN_HOME=/usr/local/maven
export PATH=$MAVEN_HOME/bin:$PATH
EOF

source /etc/profile
#检查maven环境变量是否设置成功
mvn -version