#!/usr/bin/env bash
cd $(dirname $0)

sudo apt -y update
sudo apt -y install curl software-properties-common gnupg2 -y
sudo apt -y upgrade
#sudo reboot

# import MariaDB gpg key and add repository
curl -LsS -O https://downloads.mariadb.com/MariaDB/mariadb_repo_setup
sudo bash mariadb_repo_setup --mariadb-server-version=10.5

sudo apt update
sudo apt install mariadb-server mariadb-client -y

echo"
Enter current password for root (enter for none): 

Switch to unix_socket authentication [Y/n] n

Change the root password? [Y/n] y
New password: 
Re-enter new password: 

Remove anonymous users? [Y/n] y

Disallow root login remotely? [Y/n] y

Remove test database and access to it? [Y/n] y

Reload privilege tables now? [Y/n] y
"
sudo mariadb-secure-installation