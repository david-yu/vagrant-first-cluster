# Install NTP
sudo yum -y install ntpdate net-tools
sudo ntpdate -s time.nist.gov

# Install Docker EE
sudo yum remove docker docker-common container-selinux docker-selinux docker-engine
sudo yum install -y yum-utils
export DOCKER_EE_URL=$(cat /vagrant/ee_url)
sudo sh -c "echo ${DOCKER_EE_URL}> /etc/yum/vars/dockerurl"
sudo yum-config-manager --add-repo ${DOCKER_EE_URL}/docker-ee.repo
sudo yum makecache fast
sudo yum -y install docker-ee
sudo systemctl start docker
sudo usermod -aG docker vagrant

# Configure DeviceMapper
# https://docs.docker.com/engine/userguide/storagedriver/device-mapper-driver/#reads-with-the-devicemapper
sudo systemctl stop docker
sudo yum install -y lvm2
sudo pvcreate /dev/sdb
sudo vgcreate docker /dev/sdb
sudo lvcreate --wipesignatures y -n thinpool docker -l 95%VG
sudo lvcreate --wipesignatures y -n thinpoolmeta docker -l 1%VG
sudo lvconvert -y --zero n -c 512K --thinpool docker/thinpool --poolmetadata docker/thinpoolmeta
sudo sh -c "echo 'activation {
  thin_pool_autoextend_threshold=80
  thin_pool_autoextend_percent=20
}' >> /etc/lvm/profile/docker-thinpool.profile"
sudo lvchange --metadataprofile docker-thinpool docker/thinpool
sudo lvs -o+seg_monitor
sudo mkdir /var/lib/docker.bk
sudo sh -c "mv /var/lib/docker/* /var/lib/docker.bk"
sudo sh -c "echo '{
  \"dns\":  [\"172.17.0.1\"],
  \"storage-driver\": \"devicemapper\",
  \"storage-opts\": [
     \"dm.thinpooldev=/dev/mapper/docker-thinpool\",
     \"dm.use_deferred_removal=true\",
     \"dm.use_deferred_deletion=true\"
   ]
}' >> /etc/docker/daemon.json"
sudo systemctl start docker

# Additional step for dnsmasq on localhost
sudo sh -c "echo 'interface=vboxnet1
listen-address=172.17.0.1' >> /etc/dnsmasq.d/docker-bridge.conf"
sudo systemctl start dnsmasq
