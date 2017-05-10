Vagrant Virtualbox setup for Docker EE Engine on CentOS 7.3
========================

An exercise on installing Docker EE Engine and properly configuring Device Mapper on CentOS, which may be helpful for walking through the install and configuration of Docker EE Engine before actually doing so in production environments. This vagrant file is provided strictly for educational purposes.

## Download vagrant from Vagrant website

```
https://www.vagrantup.com/downloads.html
```

## Install Virtual Box

```
https://www.virtualbox.org/wiki/Downloads
```

## Download CentOS 7 box
```
$ vagrant init centos/7
```

## Make disk directories to store vdi files that are created for VMs in the cluster
```
$ mkdir ../vagrant-disks
```

## Create files in project to store environment variables with custom values for use by Vagrant
```
ee_url
```

## Install [vagrant-landrush](https://github.com/vagrant-landrush/landrush) plugin
```
$ vagrant plugin install landrush
```

## Bring up nodes

```
$ vagrant up centos-ucp-node1 centos-ucp-node2 centos-ucp-node3 centos-ucp-node4 centos-ucp-node5
$ vagrant landrush set ucp.local haproxy.local
$ vagrant landrush set dtr.local haproxy.local
# Flush Mac's DNS cache
$ sudo killall -HUP mDNSResponder
```

## Configure Device Mapper

After provisioning the node and installing Docker EE Engine it is highly recommended to configure DeviceMapper to use direct-lvm mode in production. You can read more about selecting Graph Drivers here: https://success.docker.com/KBase/An_Introduction_to_Storage_Solutions_for_Docker_CaaS#Selecting_Graph_Drivers

### Second Storage Device provisioned by Vagrant

The best practice for configuring DeviceMapper with Docker is to provide a spare block device to create a logical volume as a thinpool for the graph driver storage. The Vagrantfile included below will create a second storage device in `/dev/sdb` with 20GB of space. You can verify this when you run `fdisk -l` you should be able to see the disks that are available to you.

```
[vagrant@centos-node ~]$ sudo su -
[root@centos-node ~]# fdisk -l

Disk /dev/sda: 42.9 GB, 42949672960 bytes, 83886080 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x000dc137

  Device Boot      Start         End      Blocks   Id  System
/dev/sda1            2048        4095        1024   83  Linux
/dev/sda2   *        4096     2101247     1048576   83  Linux
/dev/sda3         2101248    83886079    40892416   8e  Linux LVM

Disk /dev/sdb: 21.5 GB, 21474836480 bytes, 41943040 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/mapper/VolGroup00-LogVol00: 40.2 GB, 40231763968 bytes, 78577664 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/mapper/VolGroup00-LogVol01: 1610 MB, 1610612736 bytes, 3145728 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
```
### Configure Device Mapper

Configure Docker to use DeviceMapper as the graph storage driver: [Configure Docker With DeviceMapper](https://docs.docker.com/engine/userguide/storagedriver/device-mapper-driver/#/configure-docker-with-devicemapper)

### Validate Docker Device Mapper Config

Before properly configuring Docker with Device Mapper:

```
[vagrant@centos-node ~]$ docker info
Containers: 0
 Running: 0
 Paused: 0
 Stopped: 0
Images: 0
Server Version: 17.03.1-ee-3
Storage Driver: overlay
 Backing Filesystem: xfs
 Supports d_type: true
Logging Driver: json-file
...
```

After properly configuring Docker with Device Mapper:

```
[vagrant@centos-node ~]$ docker info
[vagrant@centos-ucp-node2 ~]$ sudo docker info
Containers: 0
 Running: 0
 Paused: 0
 Stopped: 0
Images: 0
Server Version: 17.03.1-ee-3
Storage Driver: devicemapper
 Pool Name: docker-thinpool
 Pool Blocksize: 524.3 kB
 Base Device Size: 10.74 GB
 Backing Filesystem: xfs
 Data file:
 Metadata file:
 Data Space Used: 19.92 MB
 Data Space Total: 20.4 GB
 Data Space Available: 20.38 GB
 Metadata Space Used: 61.44 kB
 Metadata Space Total: 213.9 MB
 Metadata Space Available: 213.8 MB
 Thin Pool Minimum Free Space: 2.039 GB
 Udev Sync Supported: true
 Deferred Removal Enabled: true
 Deferred Deletion Enabled: true
 Deferred Deleted Device Count: 0
 Library Version: 1.02.135-RHEL7 (2016-11-16)
Logging Driver: json-file
Cgroup Driver: cgroupfs
Plugins:
 Volume: local
 Network: bridge host macvlan null overlay
Swarm: inactive
Runtimes: runc
Default Runtime: runc
Init Binary: docker-init
containerd version: 4ab9917febca54791c5f071a9d1f404867857fcc
runc version: 54296cf40ad8143b62dbcaa1d90e520a2136ddfe
init version: 949e6fa
Security Options:
 seccomp
  Profile: default
Kernel Version: 3.10.0-514.2.2.el7.x86_64
Operating System: CentOS Linux 7 (Core)
OSType: linux
Architecture: x86_64
CPUs: 2
Total Memory: 1.796 GiB
Name: centos-ucp-node2
ID: NC6P:NAW7:SKY2:HSXJ:HK3L:A3XZ:BGBY:D6KG:Z6YE:CECS:OU3R:265C
Docker Root Dir: /var/lib/docker
Debug Mode (client): false
Debug Mode (server): false
Registry: https://index.docker.io/v1/
...
```

## Stop nodes

```
$ vagrant halt centos-ucp-node1 centos-ucp-node2 centos-ucp-node3 centos-ucp-node4 centos-ucp-node5
```

## Destroy nodes

```
$ vagrant destroy centos-ucp-node1 centos-ucp-node2 centos-ucp-node3 centos-ucp-node4 centos-ucp-node5
```
