#!/bin/bash
#Author:运维艄公
#Blog:http://www.opstrend.cn
#Time:2019-08-26 11:18:04
#Name:git.sh
#Version:V1.0
#Description:git安装脚本

set -e

#预定义变量
export WORK_DIR=/usr/local/src
export GIT_VERSION=2.9.5
export GIT_DIR=/usr/local/git

#卸载系统yum版本git
yum remove git -y

#安装编译GIT依赖
yum -y install curl-devel expat-devel gettext-devel openssl-devel zlib-devel  gcc perl-ExtUtils-MakeMaker

#下载GIT
cd $WORK_DIR
wget https://www.kernel.org/pub/software/scm/git/git-${GIT_VERSION}.tar.gz

#解压GIT
tar -zxvf git-${GIT_VERSION}.tar.gz

#编译安装GIT
cd git-${GIT_VERSION}
make prefix=${GIT_DIR} all
make prefix=${GIT_DIR} install

#设置环境变量
#注意EOF一定要加''，这样才能保证$符号原样输出
cat > /etc/profile.d/git.sh <<'EOF'
#git environment
export GIT_HOME=/usr/local/git
export PATH=$GIT_HOME/bin:$PATH
EOF

source /etc/profile
#检查git环境变量是否设置成功
git --version