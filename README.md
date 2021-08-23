# P2Vagrant

My Vagrant on macOS journey.

--

To use this at the stage of development that you find it...

1. Either open the project in Github Desktop or download & unpack the zip file.
2. In Terminal cd intom the project directory & run...

```
vagrant up
```

## Steps

Following are the steps taken to get to where I am. Because it's primarily for self-consumption explanations are little if any.

### 1. Creating the Virtual Machine

Vagrantfile:

```
Vagrant.configure("2") do |config|
	config.vm.box = "hashicorp/bionic64"
end
```

Run:

```
vagrant up
```


