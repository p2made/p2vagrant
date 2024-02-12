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

### `./vg n`

The file in the project root, `vg`, is a script to generate `Vagrantfile`s as they are needed (so the name means `Vagrantfile Generator`... works for me 🙃).

Where `n` is the step in this setup, the `Vagrantfile` for any step can be generated with...

```
./vg n
```

I plan to move the datawithin `vg` to a data file (which may itself be a script) in an update.

### Data

All of the data that defines this Vagrant machine ai contained within `./provision/scripts/vg.sh`, with two exceptions...

1. The value of `REMOTE_FOLDER` , `/var/www` is stored in the two common functions files. This simplified matters enough to be worth the cost of the data duplication. Whan I have this project as a `v1.0.0` I may go back to look at changing this.
2. Sites configuration data is stored in `./provision/data/sites_data`. This allows adding sites without editing the script.

### Files

Apart from the `Vagrantfile `, all files you are directed to create are in...

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
05. [Install Swift (optional)](./docs/05_Install_Swift.md)
06. [Install Apache (with SSL)](./docs/06_Install_Apache.md)
07. [Install PHP (with Composer)](./docs/07_Install_PHP.md)
08. [Install MySQL](./docs/08_Install_MySQL.md)
09. [Install phpMyAdmin](./docs/09_Install_phpMyAdmin.md)
10. [Configure Sites](./docs/10_Configure_Sites.md)

<!--
11. [Page Title](./docs/11_Page_Title.md)
12. [Page Title](./docs/12_Page_Title.md)
13. [Page Title](./docs/13_Page_Title.md)
14. [Page Title](./docs/14_Page_Title.md)
15. [Page Title](./docs/15_Page_Title.md)
-->

* [Snapshots](./docs/Snapshots.md)
* [Vagrant Commands](./docs/Commands.md)

--
