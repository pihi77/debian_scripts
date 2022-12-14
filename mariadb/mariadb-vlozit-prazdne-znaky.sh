#!/usr/bin/env bash

#header
source ./config/config.sh
cd $(dirname $0)

source ./dialog/yesno.sh "MariaDB" "Konfigurácia databázy" "\n Chceš povoliť vkladanie prázdnych znakov do databázy ?" 8 60
if [[ $response == 0 ]]
then
    clear
    echo "Povoľujem"
    config_file="/etc/mysql/mariadb.conf.d/50-server.cnf" 
    text="sql-mode=''"
    echo $text | sudo tee -a "$config_file"
    sudo systemctl restart mariadb
    sudo systemctl status mariadb
    read -p "Press any key to continue... " -n1 -s
elif [[ $response == 1 ]]
    goto start 
fi