#!/usr/bin/env bash

#header
source ./config/config.sh
echo "XDebug"
echo
# system update
source ./system_update/system_update.sh
cd $(dirname $0)

# install xdebug
source ./dialog/yesno.sh "XDebug" "Inštalácia balíčkov" "\n Chceš inštalovať XDebug?" 8 60
if [[ $response == 0 ]]
then
    clear
    echo "Inštalujem XDebug"
    sudo apt install php-xdebug -y

    # edit xdebug.ini
    config_file="/etc/php/8.1/mods-available/xdebug.ini" 
    printf "Konfiguračný súbor: ${COLOR1} $config_file ${NC}"
    xdebug_config_file="./xdebug_ini.conf"
    cat "$xdebug_config_file" | sudo tee -a "$config_file"

    # edit php.ini
    config_file="/etc/php/8.1/apache2/php.ini" 
    printf "Konfiguračný súbor: ${COLOR1} $config_file ${NC}"
    xdebug_config_file="./xdebug_php_ini.conf"
    cat "$xdebug_config_file" | sudo tee -a "$config_file"
fi

#restart apache
clear
sudo systemctl restart apache2
sudo systemctl status apache2
read -p "Press any key to continue... " -n1 -s