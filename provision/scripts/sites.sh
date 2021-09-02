#!/bin/bash

yes | cp /var/www/provision/vhosts/* /etc/apache2/sites-available/

a2ensite example.tld.conf
a2ensite example1.tld.conf
a2ensite example2.tld.conf
a2ensite example3.tld.conf
a2ensite example4.tld.conf

sudo service apache2 restart
