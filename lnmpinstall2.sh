#!/bin/bash
# YUM update and install LNMP
yum -y update
cd /root/lnmp1.2-full
printf '%s\n' 1qaz2wsx y 5 5 1|./install.sh lnmp
rm $0
