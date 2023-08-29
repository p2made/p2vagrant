# P2Vagrant (Apple Silicon)

My Vagrant on macOS - now also Apple Silicon - journey.

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

# <a id="steps"></a> Steps Taken to build this macOS/Ubuntu VM

Following are the steps taken to get to where I am. Because it's primarily for self-consumption explanations are little if any.

All versions of `Vagrantfile` are in `/Vagrantfiles` as `Vagrantfile_nn`, where `nn` is the step that Vagrantfile is for. You can restore any version of `Vagrantfile` with...

```
cp ./Vagrantfiles/Vagrantfile_nn ./Vagrantfile
``` 

All files you are directed to create are in...

```
/provision
	/html
	/scripts
	/ssl
	/templates
	/vhosts
```

01. [Install Software](./docs/01_Install_Software.md)
02. [Create Virtual Machine](./docs/02_Create_Virtual_Machine.md)
03. [Install Apache](./docs/03_Install_Apache.md)
04. [Install PHP](./docs/04_Install_PHP.md)

<!--
05. [Install MySQL](./docs/05_Install_MySQL.md)
06. [Install phpMyAdmin](./docs/06_Install_phpMyAdmin.md)
07. [Domain Names](./docs/07_Domain_Names.md)
08. [SSL](./docs/08_SSL.md)
09. [Install Composer](./docs/09_Install_Composer.md)
10. [Install Yarn](./docs/10_Install_Yarn.md)
11. [Profile](./docs/11_Profile.md)
-->

* [Vagrant Commands](./docs/Commands.md)

--
