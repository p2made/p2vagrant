# 09 Configure Sites

**Updated:** 2024-02-03

--

### ### Create `provision/data/sites_data`

```
# Sites data
# one site per space separated line
# domain template_num [vhosts_prefix]
example.test 1 000
# subdomains
#subdomain1.example.test 0
#subdomain2.example.test 0
```

Using a data file means that more sites can be added simply by updating the data file & running this provisioning script again. **Do not** do this to change sites already created.

The data file is a simple format. There is one space delimited line for each site. Lines beginning with `#` are treated as comments & ignored. The fields are...

1. `domain` - If you're reading this, you know what a domain is. All the domains in this project are on the `.test` TLD.
2. `template_number` - The numeric part of a `vhosts` template filename, `n.conf`, where `n` is this value. Currently there are `0.conf` for a basic `vhosts` file, &  `1.conf` for a more advanced one.
3. `vhosts_prefix` - An optional field to prefix the `vhosts` filename. Useful for setting the order in which Apache loads `vhosts` files. Most commonly a 3 digit string, `000`.

### Create `provision/scripts/upgrade_vm.fish`

some_text

```
some_code
```

### section_title

some_text

```
some_code
```

### Update `Vagrantfile`

```
vagrantfile
```

Or copy this file...

```
cp ./Vagrantfiles/Vagrantfile_09 ./Vagrantfile
```

### Provision the VM...

If the VM is **not** running

```
vagrant up --provision
```

If the VM is running

```
vagrant reload --provision
```

### All good?

Save the moment with a [Snapshot](./Snapshots.md).

--

| [08 Upgrade VM (revisited)](./08_Upgrade_VM.md)
| [**Back to Steps**](../README.md)
| [10 Page Title](./10_Page_Title.md)
|
