# 1. Creating the Virtual Machine

First you must...

* [Download and install the Fusion 2023 Tech Preview](https://customerconnect.vmware.com/downloads/get-download?downloadGroup=FUS-TP2023)

That installs `VMware Fusion Tech Preview` in your `Applications` folder. Rename it to `VMware Fusion`.

--

### Vagrantfile:

* The variables aren't yet necessary, but we may as well fill them in now.
* `v.gui` needs to be set to `true`.
* We might as well set `v.memory` & `v.cpus` while we're at it.
* `vmware_desktop` doesn't like `v.name`, so it's commented out.

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

# Variables
PROJECT_NAME        = "Awesome Test Project"
MEMORY              = 4096
CPUS                = 1
VM_IP               = "192.168.98.99"
TLD                 = "tld"
HOST_FOLDER         = "."
REMOTE_FOLDER       = "/var/www"
PHP_VERSION         = "8.0"
PHPMYADMIN_VERSION  = "5.1.1"
MYSQL_VERSION       = "5.7"
COMPOSER_VERSION    = "2.1.6"
RT_PASSWORD         = "password"
DB_USERNAME         = "user"
DB_PASSWORD         = "password"
DB_NAME             = "db"
DB_NAME_TEST        = "db_test"

Vagrant.configure("2") do |config|

	config.vm.box = "bento/ubuntu-20.04-arm64"

	config.vm.provider "vmware_desktop" do |v|
#		v.name   = PROJECT_NAME
		v.memory = MEMORY
		v.cpus   = CPUS
		v.gui    = true
	end

end
```

### Run:

```
vagrant up
```

--
* [Back to Steps](./00_Steps.md)
* [Installing Apache](./02_Apache.md)
