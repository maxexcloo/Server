#!/bin/bash
cd $(dirname $0)

function install_basic {
	apt-get -q -y update
	apt-get -q -y clean
}

function install_exim {
	apt-get -q -y install exim4
	sed -i "s/dc_eximconfig_configtype='local'/dc_eximconfig_configtype='internet'/" /etc/exim4/update-exim4.conf.conf
	invoke-rc.d exim4 restart
}

function install_extra {
	apt-get -q -y install php5-apc
	apt-get -q -y install php5-cli
	apt-get -q -y install php5-gd
	apt-get -q -y install php5-sqlite
	invoke-rc.d php5-fpm restart
	invoke-rc.d nginx restart
}

function install_messages {
	echo Be sure to run mysql_secure_installation to secure your MySQL install!
}

function install_mysql {
	apt-get -q -y install mysql-server
	apt-get -q -y install php5-mysql
	invoke-rc.d mysql stop
	cp -R settings/mysql /etc/
	rm -f /var/lib/mysql/ib*
	invoke-rc.d mysql start
}

function install_nginx {
	apt-get -q -y install nginx
	rm -rf /etc/nginx/conf.d/* /etc/nginx/sites-* /var/log/ngnix/*
	cp -R settings/nginx /etc/
	invoke-rc.d nginx restart
}

function install_php {
	apt-get -q -y install php5-fpm
	rm /etc/php5/fpm/pool.d/*
	cp -R settings/php5 /etc/
	cp -R settings/nginx/conf.d/php.conf /etc/nginx/conf.d/php.conf
	invoke-rc.d php5-fpm restart
}

#################
## Init Script ##
#################

case "$1" in
	# Installs Packages
	full)
		install_basic
		install_nginx
		install_php
		install_mysql
		install_exim
		install_extra
		install_basic
		install_messages
	;;
	# Shows Help
	*)
		echo \>\> You must run this script with options. They are outlined below:
		echo For a full install \(NGINX + PHP + MySQL + Exim\): bash server.sh full
	;;
esac
