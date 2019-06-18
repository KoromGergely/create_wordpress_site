#!/bin/bash
# Create a fresh wordpress install
clear
echo "============================================"
echo "WordPress Telepítő Script"
echo "============================================"

echo "Add meg a Wordpress projekt nevét! demo.shiwaforce esetén, elég a demo szót megadni!: "
read -e websiteurl
mkdir -p /var/www/com.shiwaforce/$websiteurl

echo "Add meg az adatbázis paramétereit! DB name, username, és password"

echo "Adatbázis neve: "
read -e dbname
echo "Adatbázis felhasználónév:"
read -e dbuser
echo "Adatbázis jelszó:"
read -s dbpass
echo "Mehet a telepítés? (y/n)"
read -e run

if [ "$run" == n ] ; then
exit

else
echo "============================================"
echo "A telepítő elkezdi a Wordpress site futtattását!."
echo "============================================"

#touch /etc/apache2/sites-available/com.shiwaforce.$websiteurl
#ln -s
#apache restart


cd /opt
wget -c http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz > /dev/null
cp -rf ./wordpress/*    /var/www/com.shiwaforce/$websiteurl

cd /var/www/com.shiwaforce/$websiteurl
cp wp-config-sample.php wp-config.php

#set database details with perl find and replace
perl -pi -e "s/database_name_here/$dbname/g" wp-config.php
perl -pi -e "s/username_here/$dbuser/g" wp-config.php
perl -pi -e "s/password_here/$dbpass/g" wp-config.php


# hozzuk létre a vhost file-okat
cp /opt/vhost_sample.conf /etc/apache2/sites-available/com.shiwaforce.$websiteurl
sed -i "s/test/${websiteurl}/g" /etc/apache2/sites-available/com.shiwaforce.$websiteurl
ln -s /etc/sites-available/com.shiwaforce.$websiteurl /etc/sites-enabled/
apache2ctl -t

# ide egy feltétel vizsgálat ha OK akkor mehet a restart

apache2 restart

#create uploads folder and set permissions
mkdir wp-content/uploads
chmod 775 wp-content/uploads
#chown -R com.shiwaforce.preview:com.shiwaforce.preview /var/www/com.shiwaforce/$websiteurl

echo "Törlöm a felesleges file-okat..."

rm -rf /opt/wordpress/*
rm /opt/latest.tar.gz
echo "Wordpress telepítve!!"

echo "Ne felejtsd el:DB-t létrehozni a megfelelő adatokka és a DNS-t felvenni!"
fi
