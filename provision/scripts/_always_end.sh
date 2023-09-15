#!/bin/bash

# 99 always at end of VM load

echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### #####"
echo "##### #####       End of VM Loading"
echo "##### #####"
echo "##### #####       should always run"
echo "##### #####       should run last"
echo "##### #####"
echo "##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### #####"\n


echo "Restart services..."
service php8.2-fpm restart
service apache2 restart
#service mysql restart
