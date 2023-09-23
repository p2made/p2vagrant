# 02 Upgrade VM

--

Now that there's a bare Ubuntu VM…

### Create `_vm_start.sh`

```
#!/bin/sh

# 02 Upgrade VM

echo "Update & upgrade..."
apt-get -q update
apt-get -qy upgrade
apt-get autoremove
cat /etc/os-release
```

### Update `Vagrantfile`

```
```

Or copy this file...

```
cp ./Vagrantfiles/Vagrantfile_02 ./Vagrantfile
```

### Launch the VM

```
vagrant up
```

### All good?

Save the moment with a [Snapshot](./Snapshots.md).

--

<!-- 02 Upgrade VM -->
| [01 Create Bare VM](./01_Create_Bare_VM.md)
| [**Back to Steps**](../README.md)
| [03 Install Utilities](./03_Install_Utilities.md)
|
