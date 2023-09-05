# P2Vagrant (Apple Silicon)

## <a id="steps"></a> Steps Taken to build this macOS/M2/Ubuntu VM

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

01. [Create Virtual Machine](./docs/Create_Virtual_Machine.md)

<!--
03. [Install Apache](./docs/03_Install_Apache.md)
04. [Install PHP](./docs/04_Install_PHP.md)
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
