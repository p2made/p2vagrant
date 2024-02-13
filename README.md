# P2Vagrant (Apple Silicon)

Updated: 2024-02-10

```
🇺🇦🇰🇿🇰🇬🇹🇯🇹🇲🇺🇿🇦🇿🇲🇳🇺🇦🇰🇿🇰🇬🇹🇯🇹🇲🇺🇿🇦🇿🇲🇳🇺🇦🇰🇿🇰🇬🇹🇯🇹🇲🇺🇿🇦🇿🇲🇳🇺🇦🇰🇿🇰🇬🇹🇯🇹🇲🇺🇿🇦🇿🇲🇳🇺🇦
🇺🇦
🇺🇦                ___                                     __
🇺🇦          ____ |__ \_   ______ _____ __________ _____  / /_
🇺🇦         / __ \__/ / | / / __ `/ __ `/ ___/ __ `/ __ \/ __/
🇺🇦        / /_/ / __/| |/ / /_/ / /_/ / /  / /_/ / / / / /_
🇺🇦       / .___/____/|___/\__,_/\__, /_/   \__,_/_/ /_/\__/
🇺🇦      /_/                    /____/
🇺🇦
🇺🇦                        _
🇺🇦                       (_)____   ____ _
🇺🇦                      / / ___/  / __ `/
🇺🇦                     / (__  )  / /_/ /   _ _ _
🇺🇦                    /_/____/   \__,_/   (_|_|_)
🇺🇦
🇺🇦                        ___
🇺🇦                  _____|_  )                   _           _
🇺🇦         /\      |  __ \/ /                   (_)         | |
🇺🇦        /  \     | |__)/___|   _ __  _ __ ___  _  ___  ___| |_
🇺🇦       / /\ \    |  ___/      | '_ \| '__/ _ \| |/ _ \/ __| __|
🇺🇦      / ____ \   | |          | |_) | | | (_) | |  __/ (__| |_
🇺🇦     /_/    \_\  |_|          | .__/|_|  \___/| |\___|\___|\__|
🇺🇦                              | |            _/ |
🇺🇦                              |_|           |__/
🇺🇦
🇺🇦
🇺🇦🇰🇿🇰🇬🇹🇯🇹🇲🇺🇿🇦🇿🇲🇳🇺🇦🇰🇿🇰🇬🇹🇯🇹🇲🇺🇿🇦🇿🇲🇳🇺🇦🇰🇿🇰🇬🇹🇯🇹🇲🇺🇿🇦🇿🇲🇳🇺🇦🇰🇿🇰🇬🇹🇯🇹🇲🇺🇿🇦🇿🇲🇳🇺🇦
```

## Steps Taken to build this macOS/M2/Ubuntu VM

01. [Create Bare VM](./docs/01_Create_Bare_VM.md)
02. [Upgrade VM](./docs/02_Upgrade_VM.md)
03. [Install Utilities](./docs/03_Install_Utilities.md)
04. [Upgrade VM (revisited)](./docs/04_Upgrade_VM.md)
05. [Install Swift (optional)](./docs/05_Install_Swift.md)
06. [Install Apache (with SSL & Markdown)](./docs/06_Install_Apache.md)
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

### `./vg n`

`Vagrantfile`s are generated as they are needed  by a script in the project root, `vg`  (for `Vagrantfile Generator`... works for me 🙃). `vg` takes one argument,  `n`, the step in this setup. So any `Vagrantfile` can be generated with...

```
./vg n
```

### Data

All of the data that defines this Vagrant machine is contained within `./provision/data/vagrantfiles_data.sh`, with one exception...

* The value of `VM_FOLDER` , `/var/www`, is stored in the two common functions files. This simplified matters enough to be worth the cost of the data duplication. Whan I have this project as a `v1.0.0` I may go back to look at changing this.

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

--

\* `P2` is for `P squared` because my initials are PP.

--
