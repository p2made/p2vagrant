# P2Vagrant

My Vagrant on macOS journey.

--

To use this at the stage of development that you find it...

1. Either open the project in Github Desktop or download & unpack the zip file.
2. In Terminal `cd` into the project directory & run...

```
vagrant up
```

**But you almost certainly DO NOT want to do that.**

## Steps Taken

If you want to see all the steps taken to create this VM, [here they are](./docs/00_Steps.md).

--

### <a id="step_01"></a> 1. Create the Virtual Machine

`Vagrantfile`:

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

	config.vm.box = "hashicorp/bionic64"

end
```

Run:

```
vagrant up
```

--

### <a id="step_02"></a> 2. Install Apache

* Start using variables so all the customisation is in one place.

Vagrantfile:

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Variables
PROJECT_NAME        = "Amazing Test Project"
MEMORY              = 4096
CPUS                = 1
IP                  = "192.168.88.188"
HOST_FOLDER         = "."
REMOTE_FOLDER       = "/var/www"

Vagrant.configure("2") do |config|

	config.vm.box = "hashicorp/bionic64"

	config.vm.provider "virtualbox" do |v|
		v.name = PROJECT_NAME
		v.memory = MEMORY
		v.cpus = CPUS
	end

	config.vm.network "private_network", ip: IP

	# Set a synced folder
	config.vm.synced_folder HOST_FOLDER, REMOTE_FOLDER, create: true, nfs: true, mount_options: ["actimeo=2"]

	# Execute shell script(s)
	config.vm.provision :shell, path: "provision/components/apache.sh"

end
```

Create `provision/components/apache.sh`:

```
#!/bin/bash

sudo LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/apache2

sudo apt-get update
sudo apt-get install -y apache2
```

Create `HOST_FOLDER/html/index.html`:

```
<html>
<head>
	<title>Amazing Test Project</title>
</head>
<body>
	<p>How cool is this?</p>
</body>
</html>
```

Run:

```
vagrant reload --provision
```

*But*, that name is more completely applied if the Vagrant box is destroyed & created again:

```
vagrant destroy
vagrant up
```

* When finished, visit [http://192.168.88.188/](http://192.168.88.188/).
* You should see the Apache default page of your VM.

The page is a simple `index.html` located within your VM in the `/var/www/html` directory, the so-called document root. This document root is the directory that's available from the outside to your server.

--

### <a id="step_03"></a> 3. Install PHP 8.0

`Vagrantfile`:

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Variables
PROJECT_NAME        = "Amazing Test Project"
MEMORY              = 4096
CPUS                = 1
IP                  = "192.168.88.188"
HOST_FOLDER         = "."
REMOTE_FOLDER       = "/var/www"
PHP_VERSION         = "8.0"

Vagrant.configure("2") do |config|

	config.vm.box = "hashicorp/bionic64"

	config.vm.provider "virtualbox" do |v|
		v.name = PROJECT_NAME
		v.memory = MEMORY
		v.cpus = CPUS
	end

	config.vm.network "private_network", ip: IP

	# Set a synced folder
	config.vm.synced_folder HOST_FOLDER, REMOTE_FOLDER, create: true, nfs: true, mount_options: ["actimeo=2"]

	# Execute shell script(s)
	config.vm.provision :shell, path: "provision/components/apache.sh"
	config.vm.provision :shell, path: "provision/components/php.sh", :args => [PHP_VERSION]

end
```

Create `provision/components/php.sh`:

```
#!/bin/bash

apt-get install software-properties-common
LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
apt-get update
apt-get install -y php$1 php$1-mysql

sed -i 's/max_execution_time = .*/max_execution_time = 60/' /etc/php/$1/apache2/php.ini
sed -i 's/post_max_size = .*/post_max_size = 64M/' /etc/php/$1/apache2/php.ini
sed -i 's/upload_max_filesize = .*/upload_max_filesize = 1G/' /etc/php/$1/apache2/php.ini
sed -i 's/memory_limit = .*/memory_limit = 512M/' /etc/php/$1/apache2/php.ini
sed -i 's/display_errors = .*/display_errors = on/' /etc/php/$1/apache2/php.ini
sed -i 's/display_startup_errors = .*/display_startup_errors = on/' /etc/php/$1/apache2/php.ini

service apache2 restart
```

Create `HOST_FOLDER/html/phpinfo.php`:

```
<?php
phpinfo();
```

Run:

```
vagrant provision
```

* When finished, [http://192.168.88.188/phpinfo.php](http://192.168.88.188/phpinfo.php), which should successfully display the PHP info page.

--

### <a id="step_04"></a> 4. Install MySQL

`Vagrantfile`:

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Variables
PROJECT_NAME        = "Amazing Test Project"
MEMORY              = 4096
CPUS                = 1
IP                  = "192.168.88.188"
HOST_FOLDER         = "."
REMOTE_FOLDER       = "/var/www"
PHP_VERSION         = "8.0"
MYSQL_VERSION       = "8.0"
RT_PASSWORD         = "password"
DB_USERNAME         = "user"
DB_PASSWORD         = "password"
DB_NAME             = "db"
DB_NAME_TEST        = "db_test"

Vagrant.configure("2") do |config|

	config.vm.box = "hashicorp/bionic64"

	config.vm.provider "virtualbox" do |v|
		v.name = PROJECT_NAME
		v.memory = MEMORY
		v.cpus = CPUS
	end

	config.vm.network "private_network", ip: IP

	# Set a synced folder
	config.vm.synced_folder HOST_FOLDER, REMOTE_FOLDER, create: true, nfs: true, mount_options: ["actimeo=2"]

	# Execute shell script(s)
	config.vm.provision :shell, path: "provision/components/apache.sh"
	config.vm.provision :shell, path: "provision/components/php.sh", :args => [PHP_VERSION]
	config.vm.provision :shell, path: "provision/components/mysql.sh", :args => [MYSQL_VERSION, RT_PASSWORD, DB_USERNAME, DB_PASSWORD, DB_NAME, DB_NAME_TEST]

end
```

Customise `RT_PASSWORD`, `DB_USERNAME`, `DB_PASSWORD`, `DB_NAME`, & `DB_NAME_TEST` to suit yourself.

Create `provision/components/mysql.sh`:

```
#!/bin/bash

# MYSQL_VERSION    $1
# RT_PASSWORD      $2
# DB_USERNAME      $3
# DB_PASSWORD      $4
# DB_NAME          $5
# DB_NAME_TEST     $6

# Install MySQL
apt-get update

debconf-set-selections <<< "mysql-server mysql-server/root_password password $2"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $2"

apt-get -y install mysql-server-$1

# Create the database and grant privileges
CMD="sudo mysql -uroot -p$2 -e"

$CMD "CREATE DATABASE IF NOT EXISTS $5"
$CMD "GRANT ALL PRIVILEGES ON $5.* TO '$3'@'%' IDENTIFIED BY '$4';"
$CMD "CREATE DATABASE IF NOT EXISTS $6"
$CMD "GRANT ALL PRIVILEGES ON $6.* TO '$3'@'%' IDENTIFIED BY '$4';"
$CMD "FLUSH PRIVILEGES;"

sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
grep -q "^sql_mode" /etc/mysql/mysql.conf.d/mysqld.cnf || echo "sql_mode = STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" >> /etc/mysql/mysql.conf.d/mysqld.cnf

service mysql restart
```

Run:

```
vagrant provision
```

Create `synced/html/db.php`:

```
<?php
$conn = mysqli_connect("localhost", "user", "password", "db");

if (!$conn) {
	die("Error: " . mysqli_connect_error());
}

echo "Connected!";
```

Peplace `localhost`, `user`, `password`, `db` with the values used in `Vagrantfile`.

* Visit [http://192.168.88.188/db.php](http://192.168.88.188/db.php) and if all went well you should be seeing the "*Connected!*" message.

--

### <a id="step_05"></a> 5. Install phpMyAdmin

`Vagrantfile`:

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Variables
PROJECT_NAME        = "Amazing Test Project"
MEMORY              = 4096
CPUS                = 1
VM_IP               = "192.168.88.188"
HOST_FOLDER         = "."
REMOTE_FOLDER       = "/var/www"
PHP_VERSION         = "8.0"
MYSQL_VERSION       = "8.0"
RT_PASSWORD         = "password"
DB_USERNAME         = "user"
DB_PASSWORD         = "password"
DB_NAME             = "db"
DB_NAME_TEST        = "db_test"
PHPMYADMIN_VERSION  = "5.1.1"

Vagrant.configure("2") do |config|

	config.vm.box = "hashicorp/bionic64"

	config.vm.provider "virtualbox" do |v|
		v.name = PROJECT_NAME
		v.memory = MEMORY
		v.cpus = CPUS
	end

	config.vm.network "private_network", ip: VM_IP

	# Set a synced folder
	config.vm.synced_folder HOST_FOLDER, REMOTE_FOLDER, create: true, nfs: true, mount_options: ["actimeo=2"]

	# Execute shell script(s)
	config.vm.provision :shell, path: "provision/components/apache.sh"
	config.vm.provision :shell, path: "provision/components/php.sh", :args => [PHP_VERSION]
	config.vm.provision :shell, path: "provision/components/mysql.sh", :args => [MYSQL_VERSION, RT_PASSWORD, DB_USERNAME, DB_PASSWORD, DB_NAME, DB_NAME_TEST]
	config.vm.provision :shell, path: "provision/components/phpmyadmin.sh", :args => [PHPMYADMIN_VERSION, DB_PASSWORD, REMOTE_FOLDER]

end
```

Create `provision/components/phpmyadmin.sh`:

```
#!/bin/bash

apt-get update
apt-get install -y unzip

debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $2"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $2"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $2"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"

apt-get install -y phpmyadmin

rm -rf /usr/share/phpmyadmin

cd /tmp
wget https://files.phpmyadmin.net/phpMyAdmin/$1/phpMyAdmin-$1-all-languages.zip
unzip phpMyAdmin-$1-all-languages.zip
rm phpMyAdmin-$1-all-languages.zip
sudo mv phpMyAdmin-$1-all-languages $3/html/phpmyadmin

sudo chown -R www-data:www-data $3/html/phpmyadmin
sudo chmod -R 755 $3/html/phpmyadmin

phpenmod mbstring
systemctl restart apache2
```

Run:

```
vagrant provision
```

* Visit [http://192.168.88.188/phpmyadmin/](http://192.168.88.188/phpmyadmin/), log in with user/password.















--

## <a id="commands"></a> Vagrant Commands

Command | Result
------- | ------
`vagrant up` | Starts the Vagrant box specified by the `Vagrantfile ` in the current directory.
`vagrant halt` | Stops the Vagrant box specified by the `Vagrantfile ` in the current directory.
`vagrant reload` | Re-runs your Vagrantfile, so used for changes in your `Vagrantfile`. Same as running `vagrant halt` then `vagrant up`.
`vagrant provision` | Re-runs your configured provisioners, so only used if you've changed any of them, or added new ones to the `Vagrantfile`.
`vagrant reload --provision` | Re-runs your `Vagrantfile` **and** your provisioners, so used if there were changes in both files.
`vagrant destroy` | Destroys the Vagrant box specified by the `Vagrantfile ` in the current directory.
`vagrant ssh` | SSH into the Vagrant box.

