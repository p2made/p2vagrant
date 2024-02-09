# P2Vagrant (Apple Silicon)

Updated: 2024-02-10

```
🇺🇦                       ___
🇺🇦                 _____|_  )                   _           _
🇺🇦        /\      |  __ \/ /                   (_)         | |
🇺🇦       /  \     | |__)/___|   _ __  _ __ ___  _  ___  ___| |_
🇺🇦      / /\ \    |  ___/      | '_ \| '__/ _ \| |/ _ \/ __| __|
🇺🇦     / ____ \   | |          | |_) | | | (_) | |  __/ (__| |_
🇺🇦    /_/    \_\  |_|          | .__/|_|  \___/| |\___|\___|\__|
🇺🇦                             | |            _/ |
🇺🇦                             |_|           |__/
```

Following are the steps taken to get to where I am. Because it's primarily for self-consumption explanations are little if any.

All versions of `Vagrantfile` are in `/Vagrantfiles` as `Vagrantfile_nn`, where `nn` is the step that Vagrantfile is for. You can restore any version of `Vagrantfile` with...

```
cp ./Vagrantfiles/Vagrantfile_nn ./Vagrantfile
```

All files you are directed to create are in...

```
/provision
	/data
	/etc
	/html
	/scripts
	/ssl
	/templates
	/vhosts
```

### <a id="steps"></a> Steps Taken to build this macOS/M2/Ubuntu VM

01. [Create Bare VM](./docs/01_Create_Bare_VM.md)
02. [Upgrade VM](./docs/02_Upgrade_VM.md)
03. [Install Utilities](./docs/03_Install_Utilities.md)
04. [Upgrade VM (revisited)](./docs/04_Upgrade_VM.md)
05. [Install Apache (with SSL)](./docs/05_Install_Apache.md)
06. [Install PHP (with Composer)](./docs/06_Install_PHP.md)
07. [Install MySQL](./docs/07_Install_MySQL.md)
08. [Install phpMyAdmin](./docs/08_Install_phpMyAdmin.md)
09. [Configure Sites](./docs/09_Configure_Sites.md)

<!--
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
