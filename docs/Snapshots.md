# Snapshots

By making regular snapshots you can go back to any previous machine state in an instant. For this project I make a snapshot at the successful completion of every step, named for that step. Using `vagrant snapshot` has failed for me, which I assume it is because I'm using Vmware as providor. So I've developed an approach using Vmware.

## Taking Snapshots

First make sure your VM isn't running…

```
vagrant halt
```

In `VMware Fusion` open the Virtual Machine Library…

- Menu > Window > Virtual Machine Library
- Command-Shift-L

Select your VM. It will be identified as `folder: default`, where `folder` is the name of the folder enclosing your `Vagrantfile`.

Open the Snapshots window…

- Menu > Virtual Machine > Snapshots…
- Command-S
- Right/Control click on the VM & select `Snapshots…`

Take a Snapshot…

- Right/Control click on `Current State` & select `Take Snapshot…`,
- Enter a name & click `Take`.
- (for the name I am using the title of the step in these docs)

Now you can re-launch the VM.

```
vagrant up
```

… or whatever `vagrant ...` command launches it for you.

## Restoring Snapshots

First make sure your VM isn't running…

```
vagrant halt
```

In the Snapshots window of `VMware Fusion`…

- Right/Control click on the snapshot that you want to restore & select `Restore Snapshot…`,
- Choose from `Save`, `Don't Save`, `Cancel`.
- (I usually choose `Don't Save` because I'm backing up from a failled next step.)

Now you can re-launch the VM.

```
vagrant up
```

… or whatever `vagrant ...` command launches it for you.

--

* [Back to README](../README.md)
