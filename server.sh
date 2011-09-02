#!/bin/bash
cd $(dirname $0)

aptitude install nginx
mv settings/nginx /etc/
rm /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
invoke-rc.d nginx restart

aptitude install php-fpm
mv settings/php5 /etc/
rm /etc/php5/fpm/pool.d/www.conf
invoke-rc.d php5-fpm restart

aptitude install mysql-server
invoke-rc.d mysql stop
mv settings/mysql /etc/
rm -f /var/lib/mysql/ib*
invoke-rc.d mysql start
mysql_secure_installation

aptitude install exim4
sed -i "s/dc_eximconfig_configtype='local'/dc_eximconfig_configtype='internet'/" /etc/exim4/update-exim4.conf.conf
invoke-rc.d exim4 restart

aptitude install php5-gd php5-mysql
gpasswd -a main www-data
