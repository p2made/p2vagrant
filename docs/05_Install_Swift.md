# 05 Install Swift

Updated: 2024-02-11

--

In addition to using `fish`, I start putting anything that's used more than once into an include file, `common_functions.fish`. Which brings us to...

### Create `provision/scripts/common_functions.fish `

```
#!/bin/fish

# 05 Install Swift (optional)

set script_name     "install_swift.fish"
set updated_date    "2024-02-11"

set active_title    "Installing Swift"
set job_complete    "Swift Installed"

# Source common functions
source /var/www/provision/scripts/common_functions.fish

header_banner $active_title $script_name $updated_date
# -- -- /%/ -- -- /%/ -- / script header -- /%/ -- -- /%/ -- --

# Arguments...
set SWIFT_VERSION  $argv[1]

# Script variables...

# Always set PACKAGE_LIST when using update_and_install_packages
set PACKAGE_LIST \
	binutils \
	libc6-dev \
	libcurl4-openssl-dev \
	libcurl4 \
	libedit2 \
	libgcc-9-dev \
	libpython2.7 \
	libpython3.8 \
	libsqlite3-0 \
	libstdc++-9-dev \
	libxml2-dev \
	libxml2 \
	libz3-dev \
	pkg-config \
	tzdata \
	uuid-dev \
	zlib1g-dev

export DEBIAN_FRONTEND=noninteractive

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

install_packages $SWIFT_PACKAGES

echo "⬇️ Downloading Swift ⬇️"
SWIFT_FILENAME_BASE="swift-$SWIFT_VERSION-RELEASE-ubuntu20.04-aarch64"
SWIFT_URL_BASE="https://download.swift.org/swift-$SWIFT_VERSION-release/ubuntu2004-aarch64/swift-$SWIFT_VERSION-RELEASE"
curl -L -O $SWIFT_URL_BASE/$SWIFT_FILENAME_BASE.tar.gz
curl -L -O $SWIFT_URL_BASE/$SWIFT_FILENAME_BASE.tar.gz.sig

echo "🕵️ Verifying download 🕵️"
wget -q -O - https://swift.org/keys/release-key-swift-5.x.asc | gpg --import -
gpg --keyserver hkp://keyserver.ubuntu.com --refresh-keys Swift
gpg --verify $SWIFT_FILENAME_BASE.tar.gz.sig

echo "🔄 Installing Swift 🔄"
tar xzf swift-5.9.2-RELEASE-ubuntu20.04-aarch64.tar.gz
mv swift-5.9.2-RELEASE-ubuntu20.04-aarch64 /usr/share/swift
ln -s /usr/share/swift/usr/bin/swift /usr/bin/swift

# Add Swift binary path to PATH
echo "export PATH=/usr/share/swift/usr/bin:$PATH" >> /home/vagrant/.bashrc
source /home/vagrant/.bashrc

# Cleanup
rm -f swift-5.9.2-RELEASE-ubuntu20.04-aarch64.*

# -- -- /%/ -- -- /%/ -- script footer -- /%/ -- -- /%/ -- --
footer_banner $job_complete
```

By moving common logic to `common_functions.fish`, I've been able to make this script, & all the ones that follow, a lot more concise.

### Update `Vagrantfile`

```
#!/bin/fish

# 05 Install Swift (optional)

set script_name     "install_swift.fish"
set updated_date    "2024-02-11"

set active_title    "Installing Swift"
set job_complete    "Swift Installed"

# Source common functions
source /var/www/provision/scripts/common_functions.fish

header_banner $active_title $script_name $updated_date
# -- -- /%/ -- -- /%/ -- / script header -- /%/ -- -- /%/ -- --

# Arguments...
set SWIFT_VERSION  $argv[1]

# Script variables...

# Always set PACKAGE_LIST when using update_and_install_packages
set PACKAGE_LIST \
	binutils \
	libc6-dev \
	libcurl4-openssl-dev \
	libcurl4 \
	libedit2 \
	libgcc-9-dev \
	libpython2.7 \
	libpython3.8 \
	libsqlite3-0 \
	libstdc++-9-dev \
	libxml2-dev \
	libxml2 \
	libz3-dev \
	pkg-config \
	tzdata \
	uuid-dev \
	zlib1g-dev

export DEBIAN_FRONTEND=noninteractive

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

install_packages $SWIFT_PACKAGES

echo "⬇️ Downloading Swift ⬇️"
SWIFT_FILENAME_BASE="swift-$SWIFT_VERSION-RELEASE-ubuntu20.04-aarch64"
SWIFT_URL_BASE="https://download.swift.org/swift-$SWIFT_VERSION-release/ubuntu2004-aarch64/swift-$SWIFT_VERSION-RELEASE"
curl -L -O $SWIFT_URL_BASE/$SWIFT_FILENAME_BASE.tar.gz
curl -L -O $SWIFT_URL_BASE/$SWIFT_FILENAME_BASE.tar.gz.sig

echo "🕵️ Verifying download 🕵️"
wget -q -O - https://swift.org/keys/release-key-swift-5.x.asc | gpg --import -
gpg --keyserver hkp://keyserver.ubuntu.com --refresh-keys Swift
gpg --verify $SWIFT_FILENAME_BASE.tar.gz.sig

echo "🔄 Installing Swift 🔄"
tar xzf swift-5.9.2-RELEASE-ubuntu20.04-aarch64.tar.gz
mv swift-5.9.2-RELEASE-ubuntu20.04-aarch64 /usr/share/swift
ln -s /usr/share/swift/usr/bin/swift /usr/bin/swift

# Add Swift binary path to PATH
echo "export PATH=/usr/share/swift/usr/bin:$PATH" >> /home/vagrant/.bashrc
source /home/vagrant/.bashrc

# Cleanup
rm -f swift-5.9.2-RELEASE-ubuntu20.04-aarch64.*

# -- -- /%/ -- -- /%/ -- script footer -- /%/ -- -- /%/ -- --
footer_banner $job_complete
```

Or run..

```
./provision/scripts/vg.sh 5
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

### Visit

* [http://192.168.22.42/](http://192.168.22.42/)

You should see a minimal page that I put there. For the Apache default page of your VM visit...

* [http://192.168.22.42/index.html](http://192.168.22.42/index.html)


### All good?

Save the moment with a [Snapshot](./Snapshots.md).

--

<!-- 05 Install Apache (with SSL) -->
| [04 Upgrade VM (revisited)](./04_Upgrade_VM.md)
| [**Back to Steps**](../README.md)
| [06 Install PHP (with Composer)](./06_Install_PHP.md)
|
