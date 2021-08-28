#!/bin/bash

yes | cp /var/www/provision/apache/vhosts/* /etc/apache2/sites-available/

a2ensite example.tld.conf

sudo service apache2 restart
