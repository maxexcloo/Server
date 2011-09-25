#!/bin/bash
cd $(dirname $0)

function install_basic {
	apt-get update
	apt-get clean
}

function install_exim {
	apt-get install exim4
	sed -i "s/dc_eximconfig_configtype='local'/dc_eximconfig_configtype='internet'/" /etc/exim4/update-exim4.conf.conf
	invoke-rc.d exim4 restart
}

function install_extra {
	apt-get install php5-apc
	apt-get install php5-cli
	apt-get install php5-gd
	apt-get install php5-sqlite
	invoke-rc.d php5-fpm restart
	invoke-rc.d nginx restart
}

function install_mysql {
	apt-get install mysql-server
	apt-get install php5-mysql
	invoke-rc.d mysql stop
	cp -R settings/mysql /etc/
	rm -f /var/lib/mysql/ib*
	invoke-rc.d mysql start
}

function install_nginx {
	apt-get install nginx
	rm /etc/nginx/conf.d/* /etc/nginx/sites-available/* /etc/nginx/sites-enabled/*
	cp -R settings/nginx /etc/
	ln -s /etc/nginx/sites-available/main /etc/nginx/sites-enabled/
	invoke-rc.d nginx restart
}

function install_php {
	apt-get install php5-fpm
	rm /etc/php5/fpm/pool.d/*
	cp -R settings/php5 /etc/
	cp -R settings/nginx/conf.d/php.conf /etc/nginx/conf.d/php.conf
	invoke-rc.d php5-fpm restart
}

#################
## Init Script ##
#################

case "$1" in
	# Installs Basic Packages
	basic)
		install_basic
		install_nginx
		install_php
		install_basic
	;;
	# Installs Full Packages
	full)
		install_basic
		install_nginx
		install_php
		install_mysql
		install_exim
		install_extra
		install_basic
	;;
	# Installs Extra Packages
	extra)
		install_extra
	;;
	# Shows Help
	*)
		echo \>\> You must run this script with options. They are outlined below:
		echo For a basic server install \(NGINX + PHP\): bash server.sh basic
		echo For a full install \(NGINX + PHP + MySQL + Exim\): bash server.sh full
		echo To set a user and install extra PHP libs: bash server.sh extra
	;;
esac
