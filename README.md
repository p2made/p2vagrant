# P2Vagrant

My Vagrant on macOS journey.

--

To use this at the stage of development that you find it...

1. Either open the project in Github Desktop or download & unpack the zip file.
2. In Terminal cd intom the project directory & run...

```
vagrant up
```

## Steps Taken

Following are the steps taken to get to where I am. Because it's primarily for self-consumption explanations are little if any.

1. [Create the Virtual Machine](#step_01)

* [Vagrant Commands](#commands)

--

### <a id="step_01"></a> 1. Create the Virtual Machine

`Vagrantfile`:

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

	config.vm.box = "hashicorp/bionic64"

end
```

Run:

```
vagrant up
```
















--

## <a id="commands"></a> Vagrant Commands

Command | Result
------- | ------
`vagrant up` | Starts the Vagrant box specified by the `Vagrantfile ` in the current directory.
`vagrant halt` | Stops the Vagrant box specified by the `Vagrantfile ` in the current directory.
`vagrant reload` | Re-runs your Vagrantfile, so used for changes in your `Vagrantfile`. Same as running `vagrant halt` then `vagrant up`.
`vagrant provision` | Re-runs your configured provisioners, so only used if you've changed any of them, or added new ones to the `Vagrantfile`.
`vagrant reload --provision` | Re-runs your `Vagrantfile` **and** your provisioners, so used if there were changes in both files.
`vagrant destroy` | Destroys the Vagrant box specified by the `Vagrantfile ` in the current directory.
`vagrant ssh` | SSH into the Vagrant box.

