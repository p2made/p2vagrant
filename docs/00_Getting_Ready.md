# 00 Geting Ready

Updated: 2024-02-15

--

Building this VM assumes the use of [Homebrew](https://brew.sh). If you don't have it installed, run...

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Variables

All the variable that define this VM are in `provision/data/vagrantfiles_data.sh`...

```
#!/bin/zsh

# vagrantfiles_data.sh
# Updated: 2024-02-15

# Data for Vagrantfil generation.

# Machine Variables
VM_HOSTNAME="p2vagrant"
VM_IP="192.168.22.42"                   # 22 = titanium, 42 = Douglas Adams's number
TIMEZONE="Australia/Brisbane"           # "Europe/London"
MEMORY=4096
CPUS=1

# Synced Folders
HOST_FOLDER="."
VM_FOLDER="/var/www"

# Software Versions
PHP_VERSION="8.3"
MYSQL_VERSION="8.3"
SWIFT_VERSION="5.9.2"                   # For installing Swift (optional)

# Database Variables
ROOT_PASSWORD="RootPassw0rd"
DB_USERNAME="fredspotty"
DB_PASSWORD="Passw0rd"
DB_NAME="example_db"
DB_NAME_TEST="example_db_test"
```

In a table, with my brief suggestions about changing them...

Variable | Default | Change?
-------- | ------- | -------
`VM_HOSTNAME` | `p2vagrant` | If you like ⚠️
`VM_IP` | `192.168.22.42` | If you like ⚠️
`TIMEZONE` | `Australia/Brisbane` | If you like
`MEMORY` | `4096` | Nope
`CPUS` | `1` | Nope
`HOST_FOLDER` | `.` | Nope
`VM_FOLDER` | `/var/www` | Nope
`PHP_VERSION` | `8.3` | Nope
`MYSQL_VERSION` | `8.3` | Nope
`SWIFT_VERSION` | `5.9.2` | Nope
`ROOT_PASSWORD` | `RootPassw0rd` | Totally 🚨
`DB_USERNAME` | `fredspotty` | Totally 🚨
`DB_PASSWORD` | `Passw0rd` | Totally 🚨
`DB_NAME` | `example_db` | Not really
`DB_NAME_TEST` | `example_db_test` | Not really

⚠️  Decide now whether you want to customise `VM_HOSTNAME` &/or `VM_IP`, because they're a lot harder to change later. If you do change them, remember that you need to substitute your own values every time these come up throughout the entire project.

* `VM_HOSTNAME` should be a name that is not already in use on your host Mac or LAN, & is not a TLD.
* `VM_IP` must be an IP address in the `192.168.x.x` range, that is not in use on your host Mac, or any LAN that you connect to.
* If you deploy more than one VM on your Mac, they **must** have different settings for `VM_HOSTNAME` & `VM_IP`.

🚨  If security is of even trivial importance in your project, **change these**‼️ Or even change them just as a part of practicing good habits.

--

<!-- 00 Getting Ready -->
| [**Back to Steps**](../README.md)
| [01 Create Bare VM](./01_Create_Bare_VM.md)
|

--
p2vagrant - &copy; 2024, Pedro Plowman, Australia 🇦🇺
