#!/bin/bash
#Author:运维艄公
#Blog:http://www.opstrend.cn
#Time:2019-08-26 13:29:55
#Name:node.sh
#Version:V1.0
#Description:nodejs配置.

set -e

#预定义变量
export WOKR_DIR=/usr/local/src
export NODEJS_VERSION=v12.8.0

#下载nodejs
cd $WOKR_DIR
wget https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/${NODEJS_VERSION}/node-${NODEJS_VERSION}-linux-x64.tar.gz
tar -zxvf node-${NODEJS_VERSION}-linux-x64.tar.gz
mv node-${NODEJS_VERSION}-linux-x64 /usr/local/nodejs

#设置nodejs环境变量
#注意EOF一定要加''，这样才能保证$符号原样输出
cat > /etc/profile.d/nodejs.sh <<'EOF'
#nodejs environment
export NODEJS_HOME=/usr/local/nodejs
export PATH=$NODEJS_HOME/bin:$PATH
EOF

source /etc/profile
#检查nodejs环境变量是否设置成功
node -v