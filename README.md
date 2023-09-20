# P2Vagrant (Apple Silicon)

### <a id="steps"></a> Steps Taken to build this macOS/M2/Ubuntu VM

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

01. [Create Bare VM](./docs/01_Create_Bare_VM.md)
02. [Upgrade & Install Utilities](./docs/02_Upgrade_Install_Utilities.md)
03. [Install Apache](./docs/03_Install_Apache.md)
04. [Install PHP (& Composer)](./docs/04_Install_PHP.md)
05. [Install MySQL](./docs/05_Install_MySQL.md)
06. [Install phpMyAdmin](./docs/06_Install_phpMyAdmin.md)

* [Vagrant Commands](./docs/Commands.md)

--
