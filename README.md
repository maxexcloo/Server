Notes
=====

 + Run on a freshly installed server under root!
 + Be sure to enable the DotDeb repository for PHP-FPM support!
 + If you want to use the minimal script, run it first.
 + The server is initially configured with a root of `/home/main/http`, change it in `/etc/nginx/conf.d/hosts.d/main.conf`.

Download
========

Download the script with the following command:

	cd ~; wget --no-check-certificate -O server.tar.gz http://www.github.com/maxexcloo/Server/tarball/master; tar zxvf server.tar.gz; cd *Server*

Instructions
============

You must run this script with options. They are outlined below:

 + For a full install (NGINX + PHP + MySQL + Exim): `bash server.sh full`

Credits
=======

cedr @ daIRC: vHost Style
FreeVPS.us CentOS Server Script: http://www.freevps.us/downloads/nginx-centos-6.sh
