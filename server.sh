#!/bin/bash
cd $(dirname $0)

function install_exim {
	aptitude install exim4
	sed -i "s/dc_eximconfig_configtype='local'/dc_eximconfig_configtype='internet'/" /etc/exim4/update-exim4.conf.conf
	invoke-rc.d exim4 restart
}

function install_extra {
	aptitude install php5-gd
	gpasswd -a main www-data
}

function install_mysql {
	aptitude install mysql-server
	aptitude install php5-mysql
	invoke-rc.d mysql stop
	cp -R settings/mysql /etc/
	rm -f /var/lib/mysql/ib*
	invoke-rc.d mysql start
	mysql_secure_installation
}

function install_nginx {
	aptitude install nginx
	cp -R settings/nginx /etc/
	rm /etc/nginx/conf.d/php.conf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
	invoke-rc.d nginx restart
}

function install_php {
	aptitude install php-fpm
	cp -R settings/php5 /etc/
	rm /etc/php5/fpm/pool.d/www.conf
	cp -R settings/nginx/conf.d/php.conf /etc/nginx/conf.d/php.conf
	invoke-rc.d php5-fpm restart
}

#################
## Init Script ##
#################

case "$1" in
	# Installs Basic Packages
	basic)
		install_nginx
		install_php
	;;
	# Installs Full Packages
	full)
		install_nginx
		install_php
		install_mysql
		install_exim
	;;
	# Installs Extra Packages
	extra)
		install_extra
	;;
	# Shows Help
	*)
		echo \>\> You must run this script with options. They are outlined below:
		echo For a basic server install \(NGINX + PHP\): sh server.sh basic
		echo For a full install \(NGINX + PHP + MySQL + Exim\): sh minimal.sh full
		echo To set a user and install extra PHP libs: sh minimal.sh extra
	;;
esac
