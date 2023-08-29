# 01 Install Software

--

The instructions given assume the use of [Homebrew](https://brew.sh). If you don't have it installed, run...

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## 01 Install the VMware Fusion 2023 Tech Preview

* [This one](https://customerconnect.vmware.com/downloads/get-download?downloadGroup=FUS-TP2023) is the most recent as of [2023-07-13](https://blogs.vmware.com/teamfusion/2023/07/vmware-fusion-2023-tech-preview.html).
* Installs `VMware Fusion Tech Preview` in your `Applications` folder.
* Rename it to `VMware Fusion`
* (I don't know why that's necessary, but I read that it is, & it find that is).

## 02 Install Vagrant & VMware Utility

```
brew install --cask vagrant
brew install --cask vagrant-vmware-utility
```

### 02a Optionally install Vagrant Manager

```
brew install --cask vagrant-manager
```

## 03 Install Vagrant Plugins

```
vagrant plugin install vagrant-share
vagrant plugin install vagrant-vmware-desktop
```

## 04 Check `vagrant` status

```
vagrant global-status
```

For result something like...

```
id       name   provider state  directory                           
--------------------------------------------------------------------
There are no active Vagrant environments on this computer! Or,
you haven't destroyed and recreated Vagrant environments that were
started with an older version of Vagrant.
```

--

<!-- 01 Install Software -->
| [**Back to Steps**](../README.md)
| [02 Create Virtual Machine](./02_Create_Virtual_Machine.md)
|
