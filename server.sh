#!/bin/bash
cd $(dirname $0)

# Perform Basic APT Functions
function install_basic {
	# Update Package List
	apt-get -q -y update
	# Clean Package Cache
	apt-get -q -y clean
}

# Install & Configure Exim Mail Server
function install_exim {
	# Install Exim Mail Server
	apt-get -q -y install exim4
	# Set Up Exim For Internet Delivery
	sed -i "s/dc_eximconfig_configtype='local'/dc_eximconfig_configtype='internet'/" /etc/exim4/update-exim4.conf.conf
	# Restart Exim To Apply Changes
	invoke-rc.d exim4 restart
}

# Install Extra Packages & Restart Services
function install_extra {
	# Install PHP APC Accelerator
	apt-get -q -y install php5-apc
	# Install PHP CLI
	apt-get -q -y install php5-cli
	# Install PHP Curl File Transfer Library
	apt-get -q -y install php5-curl
	# Install PHP GD Image Library
	apt-get -q -y install php5-gd
	# Install PHP MCrypt Library (PHPMyAdmin Dependency)
	apt-get -q -y install php5-mcrypt
	# Install PHP SQLite  Library
	apt-get -q -y install php5-sqlite
	# Install Apache Utilities
	apt-get -q -y install apache2-utils
	# Install Siege Benchmark
	apt-get -q -y install siege
	# Restart PHP-FPM To Load Libraries
	invoke-rc.d php5-fpm restart
	# Restart Nginx
	invoke-rc.d nginx restart
}

# Print Post Install Messages
function install_messages {
	# Alert User About MySQL Security
	echo Be sure to run mysql_secure_installation to secure your MySQL install!
}

# Install & Configure MySQL Database Server
function install_mysql {
	# Install MySQL Server
	apt-get -q -y install mysql-server
	# Install PHP MySQL Library
	apt-get -q -y install php5-mysql
	# Stop MySQL Daemon
	invoke-rc.d mysql stop
	# Copy Settings
	cp -R settings/mysql /etc/
	# Remove InnoDB Files
	rm -f /var/lib/mysql/ib*
	# Start MySQL
	invoke-rc.d mysql start
}

# Install & Configure NGINX Web Server
function install_nginx {
	# Make Backup Directory
	mkdir ~/backups/
	# Copy Current Configuration To Backup Directory
	cp -r /etc/nginx/conf.d/ ~/backups/
	# Install NGINX
	apt-get -q -y install nginx
	# Remove System Configuration
	rm -rf /etc/nginx/conf.d/* /etc/nginx/sites-*
	# Copy Configuration
	cp -R settings/nginx /etc/
	# Restart NGINX
	invoke-rc.d nginx restart
}

# Install & Configure PHP-FPM
function install_php {
	# Install PHP-FPM
	apt-get -q -y install php5-fpm
	# Copy Configuration
	cp -R settings/php5 /etc/
	# Restart PHP-FPM
	invoke-rc.d php5-fpm restart
}

#################
## Init Script ##
#################

case "$1" in
	# Install Packages
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
	# Show Help
	*)
		echo \>\> You must run this script with options. They are outlined below:
		echo For a full install \(NGINX + PHP + MySQL + Exim\): bash server.sh full
	;;
esac
