#/bin/bash
################
# dmarcts-vagrant setup script:
# assumes we're starting from a plain Ubuntu 14.04 box
#
# per http://www.techsneeze.com/how-parse-dmarc-reports/ (for database)
# and http://www.techsneeze.com/how-parse-dmarc-reports-imap/
################

# MySQL root password; used only in this script for setting up tables
MYSQL_ROOT_PW="PopzzTA39pQya1K4"

# MySQL user password; the value here will be used to replace defaults in the
# mkdmarc script, dmarcts-report-parser.conf, and dmarcts-report-viewer-config.php
MYSQL_USER_PW="9RH1n9myr1qZJfQL"

# the default unprivileged user is "vagrant" (vagrant ssh -c whoami)
VAGRANT_USER="vagrant"

################
# install dependencies

sudo apt-get update && sudo apt-get upgrade -y

echo "mysql-server mysql-server/root_password password $MYSQL_ROOT_PW" | sudo debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PW" | sudo debconf-set-selections

sudo apt-get install -y git unzip lamp-server^ \
  libmail-imapclient-perl libmime-tools-perl libxml-simple-perl \
  libclass-dbi-mysql-perl libio-socket-inet6-perl libio-socket-ip-perl \
  libperlio-gzip-perl


################
# set up database tables used in the script

mysqladmin -uroot -p$MYSQL_ROOT_PW create dmarc

sed -e "s/xxx/$MYSQL_USER_PW/g" /vagrant/mkdmarc > ~/mkdmarc-custom-password
mysql -uroot -p$MYSQL_ROOT_PW dmarc < ~/mkdmarc-custom-password

################
# provisioning scripts run as root, but we want the files below to go in /home/vagrant

sudo su $VAGRANT_USER <<UNPRIVILEGED_COMMANDS

  # clone the parser into /home/vagrant and edit its config file
  cd /home/$VAGRANT_USER
  git clone https://github.com/techsneeze/dmarcts-report-parser.git
  cd dmarcts-report-parser
  sed -e "s/xxx/$MYSQL_USER_PW/g" dmarcts-report-parser.conf.sample > dmarcts-report-parser.conf

  # symlinks to make the quickstart instructions shorter
  cd /home/$VAGRANT_USER
  ln -s dmarcts-report-parser/dmarcts-report-parser.pl ./parser.pl
  ln -s dmarcts-report-parser/dmarcts-report-parser.conf ./dmarcts-report-parser.conf

  # now clone the web interface, edit its config file, and copy to /var/www/html
  git clone https://github.com/techsneeze/dmarcts-report-viewer.git
  cd dmarcts-report-viewer
  sed -e "s/xxx/$MYSQL_USER_PW/g" dmarcts-report-viewer-config.php.sample > dmarcts-report-viewer-config.php

UNPRIVILEGED_COMMANDS

# access to report-viewer for Apache (assumes default FollowSymLinks setting)
sudo ln -s /home/$VAGRANT_USER/dmarcts-report-viewer/* /var/www/html/

################

echo "Setup complete!"
echo "Use vagrant ssh to get in to your new VM, and run ./parser.pl on your mailboxes with DMARC attachments."
echo "Then visit http://localhost:8080/dmarcts-report-viewer.php in a browser."
