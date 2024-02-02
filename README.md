# P2Vagrant (Apple Silicon)

**Updated:** 2024-02-02

### <a id="steps"></a> Steps Taken to build this macOS/M2/Ubuntu VM

Following are the steps taken to get to where I am. Because it's primarily for self-consumption, explanations may be sparse in places.

All versions of `Vagrantfile` are in `/Vagrantfiles` as `Vagrantfile_nn`, where `nn` is the step that Vagrantfile is for. You can restore any version of `Vagrantfile` with...

```
cp ./Vagrantfiles/Vagrantfile_nn ./Vagrantfile
```

All files you are directed to create are in...

```
/provision
	/data
	/html
	/scripts
	/ssl
	/templates
	/vhosts
```

01. [Create Bare VM](./docs/01_Create_Bare_VM.md)
02. [Upgrade VM](./docs/02_Upgrade_VM.md)
03. [Install Utilities](./docs/03_Install_Utilities.md)
04. [Install Apache (with SSL)](./docs/04_Install_Apache.md)
05. [Install PHP (with Composer)](./docs/05_Install_PHP.md)
06. [Install MySQL](./docs/06_Install_MySQL.md)
07. [Install phpMyAdmin](./docs/07_Install_phpMyAdmin.md)

<!--
08. [Upgrade VM (revisited)](./docs/08_Upgrade_VM.md)
09. [Configure Sites](./docs/09_Configure_Sites.md)
10. [Page Title](./docs/10_Page_Title.md)
11. [Page Title](./docs/11_Page_Title.md)
12. [Page Title](./docs/12_Page_Title.md)
13. [Page Title](./docs/13_Page_Title.md)
14. [Page Title](./docs/14_Page_Title.md)
15. [Page Title](./docs/15_Page_Title.md)
-->

* [Snapshots](./docs/Snapshots.md)
* [Vagrant Commands](./docs/Commands.md)

--
