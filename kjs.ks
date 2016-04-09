install
text
lang zh_TW.UTF-8
keyboard us
network --onboot yes --device eth0 --bootproto dhcp --noipv6
rootpw  --iscrypted $1$fBDmsiFq$PMMFfpyJDa9ISBWp0dn0O1
firewall --port=22:tcp,80:tcp
authconfig --enableshadow --passalgo=sha512
selinux --enforcing
timezone Asia/Taipei
bootloader --location=mbr --driveorder=vda --append="crashkernel=auto rhgb quiet"
reboot

zerombr
clearpart --all
part / --fstype=ext4 --grow --asprimary
part  swap   --fstype=swap  --size=2000

services  --disabled cups,kdump,acpid,portreserve

%packages
@base
@console-internet
@core
@debugging
@directory-client
@hardware-monitoring
@java-platform
@large-systems
@network-file-system-client
@performance
@perl-runtime
@server-platform
screen
wget
unzip

%post
#!/bin/sh
useradd iscom
sed -i.bak 's/iscom\:\!/iscom\:\$1\$.sYWHs6u$okPocB\/rpzwM1yvohFlau\//g' /etc/shadow
wget -c http://soft.vpser.net/lnmp/lnmp1.2-full.tar.gz && tar zxf lnmp1.2-full.tar.gz && cd lnmp1.2-full && ./install.sh lnmp
