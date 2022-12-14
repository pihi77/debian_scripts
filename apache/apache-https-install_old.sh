#!/usr/bin/env bash

#header
source ./config/config.sh
echo "Apache, SSL certifikát a presmerovanie http->https"
echo            
# system update
source ./system_update/system_update_old.sh
cd $(dirname $0)

#install apache
read -p "Chceš inštalovať apache?" -n 1 -r
echo    # (optional) move to a new line
if [[  $REPLY =~ ^[YyAa]$ ]]
then
    echo "Inštalujem apache"
    sudo apt-get update
    sudo apt-get install apache2 openssl
fi

#set modules
read -p "Chceš nakonfigurovať https?" -n 1 -r
echo    # (optional) move to a new line
if [[  $REPLY =~ ^[YyAa]$ ]]
then
    echo "Nastavujem moduly"
    sudo a2enmod ssl
    sudo a2enmod rewrite

    #config apache
    https_config_file="./apache-https.conf"
    config_file="/etc/apache2/apache2.conf" 
    printf "Konfiguračný súbor: ${COLOR1} $config_file ${NC}"
    echo
    text="<Directory /var/www/html>AllowOverride All</Directory>"
    echo $text | sudo tee -a "$config_file"

    #create private key and certificate using OpenSSL
    echo "
    -----
    Čaká vás výzva na zadanie informácií, ktoré budú zahrnuté
    do vašej žiadosti o certifikát.
    To, čo sa chystáte zadať, sa nazýva rozlišovacie meno alebo DN.
    Existuje pomerne málo polí, ale niektoré môžete nechať prázdne
    Pre niektoré polia bude predvolená hodnota,
    Ak zadáte „.“, pole zostane prázdne.
    -----
    Country Name (2 letter code) [AU]: SK
    State or Province Name (full name) [Some-State]: Kosice
    Locality Name (eg, city) []: Kosicka Bela
    Organization Name (eg, company) [Internet Widgits Pty Ltd]: PIHI s.r.o.
    Organizational Unit Name (eg, section) []: Development
    Common Name (e.g. server FQDN or YOUR name) []: 178.18.71.177
    Email Address []: support@pihi.sk
    "
    sudo mkdir /etc/apache2/certificate
    sudo openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/apache2/certificate/apache-certificate.crt -keyout /etc/apache2/certificate/apache.key

    #config apache for default website
    config_file="/etc/apache2/sites-enabled/000-default.conf" 
    printf "Konfiguračný súbor: ${COLOR1} $config_file ${NC}"
    
    echo
    cat "$https_config_file" | sudo tee "$config_file"

    #set permission
    sudo chmod -R 777 /var/www/html
fi

#restart apache
sudo systemctl restart apache2.service
sudo systemctl status  apache2.service

