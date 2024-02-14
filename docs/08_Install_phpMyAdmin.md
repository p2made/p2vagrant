# 09 Install phpMyAdmin (manual)

Updated: 2024-02-13

--

No script & no `Vagrantfile` here, because I'm installing phpMyAdmin manually. If anybody seeing this project knows how to het `debconf-set-selections` right for phpMyAdmin, I welcome you contribution.

### Start the VM & enter the Vagrant shell

```
vagrant up
vagrant ssh
```

### Install phpMyAdmin

```
sudo LC_ALL=C.UTF-8 add-apt-repository -yu ppa:phpmyadmin/ppa

sudo apt-get update
sudo apt-get -qy install phpmyadmin
```

The installer prompts, accept the defaults & enter a password of your choosing.

### Finish phpMyAdmin Installation

First remove the phpMyAdmin folder that the installer has just put in place.

```
sudo rm -rf /usr/share/phpmyadmin
```

Now copy the phpMyAdmin folder that's part of this project, & set permissions.

```
sudo cp -R /var/www/provision/html/phpmyadmin /var/www/html/phpmyadmin
sudo chmod -R 755 /var/www/html/phpmyadmin
```

Finally, make sure a `php` module that phpMyAdmin requires is enabled.

```
sudo phpenmod mbstring
```

### Restart Apache

```
sudo service apache2 restart
```

* [https://p2vagrant/phpmyadmin/](https://p2vagrant/phpmyadmin/)
* log in with 'phpmyadmin' & the password you entered.

#### Accessing the Database from Outside the VM

To access your database with a GUI you'll need to use a SSH connection. How to set this up depends on the software you're using, but in general these are the things you'll need to configure:

Item | Value
---- | -----
`Host` | 127.0.0.1
`Username` | myuser (which we've defined in mysql.sh)
`Password` | password (which we've also defined in mysql.sh)
`SSH Host` | 127.0.0.1
`SSH User` | vagrant
`SSH Key` | Can be found in this location in your project directory: /.vagrant/machines/default/virtualbox/private_key
`SSH Port` | 2222

### All good?

Save the moment with a [Snapshot](./Snapshots.md).

--

<!-- 08 Install phpMyAdmin -->
| [07 Install MySQL](./07_Install_MySQL.md)
| [**Back to Steps**](../README.md)
| [09 Configure Sites](./09_Configure_Sites.md)
|

--

p2vagrant - &copy; 2024, Pedro Plowman, Australia 🇦🇺 🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳

--
