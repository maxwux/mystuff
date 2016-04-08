#!/bin/bash
tar -cvpzf /home/maxwux/gdrive/server\ backup/server-backup-`date +%y%m%d`.tar.gz --same-owner --exclude=/tmp/* --exclude=/proc/* --exclude=/media/* --exclude=/dev/* --exclude=/mnt/* --exclude=/sys/* --exclude=/home --exclude=/var/www/bt/* --exclude=/var/www/owncloud/* --exclude=/var/cache/* --exclude=/var/www/ftp-backup/* /
drive push /home/maxwux/gdrive/server\ backup/
rm /home/maxwux/gdrive/server\ backup/server-backup-`date +%y%m%d`.tar.gz
