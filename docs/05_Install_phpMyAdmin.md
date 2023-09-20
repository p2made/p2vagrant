# 05 Install phpMyAdmin

--

Installing phpMyAdmin using a provisioning script is failing for me, so I'm doing it manually. `Vagrantfile_05` & `provision/scripts/phpmyadmin.sh` exist in the project for preservation, but are not currently used. Lines in Vagrantfiles that relate to installing phpMyAdmin are commented out.

#### First SSH into the VM…

```
vagrant ssh
```

#### Now run…

```
LC_ALL=C.UTF-8 sudo apt-add-repository -yu ppa:phpmyadmin/ppa
sudo apt update
sudo apt -qy install phpmyadmin
```

During the install, accept the default options & enter a password of your choosing.

#### Now run…

```
sudo rm -rf /usr/share/phpmyadmin

cd /tmp
wget https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.zip
unzip phpMyAdmin-5.2.1-all-languages.zip
rm phpMyAdmin-5.2.1-all-languages.zip
sudo mv phpMyAdmin-5.2.1-all-languages /var/www/html/phpmyadmin

sudo chmod -R 755 /var/www/html/phpmyadmin
```

Permissions are fixed in the `chmod` step, so ignore the permissions failures in the `mv` step.

#### Finally run…

```
sudo phpenmod mbstring
sudo systemctl restart apache2
```

### Visit your phpMyAdmin

* [http://192.168.42.100/phpmyadmin/](http://192.168.42.100/phpmyadmin/)
* Log in with, user `phpmyadmin` & password given during the install.

#### Accessing the Database from Outside the VM

To access your database with a GUI you'll need to use a SSH connection. How to set this up depends on the software you're using, but in general these are the things you'll need to configure:

Item | Value
---- | -----
`Host` | 127.0.0.1
`Username` | phpmyadmin
`Password` | password given during the install
`SSH Host` | 127.0.0.1
`SSH User` | vagrant
`SSH Key`  | Can be found in this location in your project directory: /.vagrant/machines/default/virtualbox/private_key
`SSH Port` | 2222

--

<!-- 03 Install PHP 8.2 -->
| [04 Install MySQL](./04_Install_MySQL.md)
| [**Back to Steps**](../README.md)
| [06 Domain Names](./06_Domain_Names.md)
|
