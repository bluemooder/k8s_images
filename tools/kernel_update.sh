#!/bin/bash
#Author:运维艄公
#Blog:http://www.opstrend.cn
#Time:2019-12-05 15:47:26
#Name:kernel_update.sh
#Version:V1.0
#Description:This is a production script.

#导入公钥
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org

#安装ELRepo
yum -y install https://www.elrepo.org/elrepo-release-7.0-4.el7.elrepo.noarch.rpm

#升级内核
yum --enablerepo=elrepo-kernel install -y kernel-lt
# 安装完成后检查 /boot/grub2/grub.cfg 中对应内核 menuentry 中是否包含 initrd16 配置，如果没有，再安装一次！
awk -F\' '$1=="menuentry " {print $2}' /etc/grub2.cfg
# 设置开机从新内核启动
grub2-set-default 0
# 重新启动系统
reboot