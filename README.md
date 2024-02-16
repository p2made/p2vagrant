# P2Vagrant (Apple Silicon)

## About `P2Vagrant`\*

Out of the box, `P2Vagrant` gives you...

* [fish shell](https://fishshell.com)
* the ability to install [Swift](https://www.swift.org)
* [Apache2](https://www.apache.org) (with SSL & [Markdown](https://en.wikipedia.org/wiki/Markdown))
* [self-signed SSL](https://en.wikipedia.org/wiki/Self-signed_certificate)
* [PHP](https://www.php.net) (with [Composer](https://getcomposer.org))
* [MySQL Community Server](https://www.mysql.com/products/community/)
* [phpMyAdmin](https://www.phpmyadmin.net)
* the ability to configure unlimited websites

## Steps Taken to build this macOS/M2/Ubuntu VM

* 00 [Getting Ready](./docs/00_Getting_Ready.md)
* 01 [Create Bare VM](./docs/01_Create_Bare_VM.md)
* 02 [Upgrade VM](./docs/02_Upgrade_VM.md)
* 03 [Install Utilities](./docs/03_Install_Utilities.md)
* 04 [Install Swift **(¡¡ optional !!)**](./docs/04_Install_Swift.md)
* 05 [Install Apache (with SSL & Markdown)](./docs/05_Install_Apache.md)
* 06 [Install PHP (with Composer)](./docs/06_Install_PHP.md)
* 07 [Install MySQL](./docs/07_Install_MySQL.md)
* 08 [Install phpMyAdmin](./docs/08_Install_phpMyAdmin.md)
* 09 [Configure Sites](./docs/09_Configure_Sites.md)

<!--
* 10 [Page Title](./docs/10_Page_Title.md)
* 11 [Page Title](./docs/11_Page_Title.md)
* 12 [Page Title](./docs/12_Page_Title.md)
* 13 [Page Title](./docs/13_Page_Title.md)
* 14 [Page Title](./docs/14_Page_Title.md)
* 15 [Page Title](./docs/15_Page_Title.md)
-->

* [Snapshots](./docs/Snapshots.md)
* [Vagrant Commands](./docs/Commands.md)

## `./vg n`

`Vagrantfile`s are generated as they are needed  by a script in the project root, `vg`  (for `Vagrantfile Generator`... works for me 🙃). `vg` takes one argument,  `n`, the step in this setup. So any `Vagrantfile` can be generated with...

```
./vg n
```

## Data

All of the data that defines this Vagrant machine is contained within `./provision/data/vagrantfiles_data.sh`, with one exception...

* The value of `VM_FOLDER` , `/var/www`, is stored in the two common functions files. This simplified matters enough to be worth the cost of the data duplication. Whan I have this project as a `v1.0.0` I may go back to look at changing this.

## Files

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

--

\* `P2` is for `P squared` because my initials are PP.

--

p2vagrant - &copy; 2024, Pedro Plowman, Australia 🇦🇺 🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳

--
