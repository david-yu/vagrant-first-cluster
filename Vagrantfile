# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.

    # Docker EE node for CentOS 7.3
    config.vm.define "haproxy" do |haproxy_node|
      haproxy_node.vm.box = "ubuntu/xenial64"
      haproxy_node.vm.network "private_network", ip: "172.28.128.30"
      haproxy_node.vm.hostname = "haproxy.local"
      haproxy_node.hostsupdater.aliases = ["ucp.local", "dtr.local"]
      config.vm.provider :virtualbox do |vb|
         vb.customize ["modifyvm", :id, "--memory", "1024"]
         vb.customize ["modifyvm", :id, "--cpus", "1"]
         vb.name = "haproxy-node"
      end
      haproxy_node.landrush.enabled = true
      haproxy_node.landrush.tld = 'local'
      haproxy_node.landrush.host 'dtr.local', '172.28.128.30'
      haproxy_node.landrush.host 'ucp.local', '172.28.128.30'
      haproxy_node.vm.provision "shell", inline: <<-SHELL
       sudo apt-get update
       sudo apt-get install -y apt-transport-https ca-certificates ntpdate
       sudo ntpdate -s time.nist.gov
       sudo apt-get install -y software-properties-common
       sudo add-apt-repository ppa:vbernat/haproxy-1.7
       sudo apt-get update
       sudo apt-get install -y haproxy
       ifconfig enp0s8 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}' > /vagrant/haproxy-node
       sudo sed -i '/module(load="imudp")/s/^#//g' /etc/rsyslog.conf
       sudo sed -i '/input(type="imudp" port="514")/s/^#//g' /etc/rsyslog.conf
       sudo service rsyslog restart
       sudo cp /vagrant/files/haproxy.cfg /etc/haproxy/haproxy.cfg
       sudo service haproxy restart
      SHELL
    end

    # Docker EE node for CentOS 7.3
    config.vm.define "ucp-node1" do |centos_ucp_node1|
      disk = '../vagrant-disks/vagrant-disk.vdi'
      centos_ucp_node1.vm.box = "centos/7"
      centos_ucp_node1.vm.network "private_network", ip: "172.28.128.31"
      centos_ucp_node1.landrush.tld = 'local'
      centos_ucp_node1.vm.hostname = "ucp-node1.local"
      centos_ucp_node1.landrush.enabled = true
      centos_ucp_node1.vm.provider :virtualbox do |vb|
        unless File.exist?(disk)
          vb.customize ['createhd', '--filename', disk, '--variant', 'Fixed', '--size', 20 * 1024]
        end
        vb.customize ['storageattach', :id,  '--storagectl', 'IDE', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', disk]
        vb.customize ["modifyvm", :id, "--memory", "2500"]
        vb.customize ["modifyvm", :id, "--cpus", "2"]
        vb.name = "centos-ucp-node1"
      end
      centos_ucp_node1.vm.provision "shell", inline: <<-SHELL
        sudo yum -y remove docker
        sudo yum -y remove docker-selinux
        sudo yum -y install ntpdate net-tools
        sudo ntpdate -s time.nist.gov
        sudo cp /vagrant/scripts/install_ee.sh .
        sudo cp /vagrant/scripts/install_ucp.sh .
        sudo cp /vagrant/scripts/create_tokens.sh .
        sudo chmod +x install_ee.sh
        sudo chmod +x install_ucp.sh
        sudo chmod +x create_tokens.sh
        sudo hostname -I | awk '{print $2}' > /vagrant/centos-ucp-node1
        # ./install_ee.sh
     SHELL
    end

    # Docker EE node for CentOS 7.3
    config.vm.define "ucp-node2" do |centos_ucp_node2|
      disk = '../vagrant-disks/vagrant-disk2.vdi'
      centos_ucp_node2.vm.box = "centos/7"
      centos_ucp_node2.vm.network "private_network", ip: "172.28.128.32"
      centos_ucp_node2.landrush.tld = 'local'
      centos_ucp_node2.vm.hostname = "ucp-node2.local"
      centos_ucp_node2.landrush.enabled = true
      centos_ucp_node2.vm.provider :virtualbox do |vb|
        unless File.exist?(disk)
          vb.customize ['createhd', '--filename', disk, '--variant', 'Fixed', '--size', 20 * 1024]
        end
        vb.customize ['storageattach', :id,  '--storagectl', 'IDE', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', disk]
        vb.customize ["modifyvm", :id, "--memory", "2500"]
        vb.customize ["modifyvm", :id, "--cpus", "2"]
        vb.name = "centos-ucp-node2"
      end
      centos_ucp_node2.vm.provision "shell", inline: <<-SHELL
        sudo yum -y remove docker
        sudo yum -y remove docker-selinux
        sudo yum -y install ntpdate net-tools
        sudo ntpdate -s time.nist.gov
        sudo cp /vagrant/scripts/install_ee.sh .
        sudo chmod +x install_ee.sh
        ./install_ee.sh
      SHELL
    end

    # Docker EE node for CentOS 7.3
    config.vm.define "ucp-node3" do |centos_ucp_node3|
      disk = '../vagrant-disks/vagrant-disk3.vdi'
      centos_ucp_node3.vm.box = "centos/7"
      centos_ucp_node3.vm.network "private_network", ip: "172.28.128.33"
      centos_ucp_node3.landrush.tld = 'local'
      centos_ucp_node3.vm.hostname = "ucp-node3.local"
      centos_ucp_node3.landrush.enabled = true
      centos_ucp_node3.vm.provider :virtualbox do |vb|
        unless File.exist?(disk)
          vb.customize ['createhd', '--filename', disk, '--variant', 'Fixed', '--size', 20 * 1024]
        end
        vb.customize ['storageattach', :id,  '--storagectl', 'IDE', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', disk]
        vb.customize ["modifyvm", :id, "--memory", "2048"]
        vb.customize ["modifyvm", :id, "--cpus", "2"]
        vb.name = "centos-ucp-node3"
      end
      centos_ucp_node3.vm.provision "shell", inline: <<-SHELL
       sudo yum -y remove docker
       sudo yum -y remove docker-selinux
       sudo yum -y install ntpdate net-tools
       sudo ntpdate -s time.nist.gov
       sudo cp /vagrant/scripts/install_ee.sh .
       sudo chmod +x install_ee.sh
       ./install_ee.sh
     SHELL
    end

    # Docker EE node for CentOS 7.3
    config.vm.define "dtr-node1" do |centos_dtr_node1|
      disk = '../vagrant-disks/vagrant-disk4.vdi'
      centos_dtr_node1.vm.box = "centos/7"
      centos_dtr_node1.vm.network "private_network", ip: "172.28.128.34"
      centos_dtr_node1.landrush.tld = 'local'
      centos_dtr_node1.vm.hostname = "dtr-node1.local"
      centos_dtr_node1.landrush.enabled = true
      centos_dtr_node1.vm.provider :virtualbox do |vb|
        unless File.exist?(disk)
          vb.customize ['createhd', '--filename', disk, '--variant', 'Fixed', '--size', 20 * 1024]
        end
        vb.customize ['storageattach', :id,  '--storagectl', 'IDE', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', disk]
        vb.customize ["modifyvm", :id, "--memory", "2048"]
        vb.customize ["modifyvm", :id, "--cpus", "2"]
        vb.name = "centos-dtr-node1"
      end
      centos_dtr_node1.vm.provision "shell", inline: <<-SHELL
       sudo yum -y remove docker
       sudo yum -y remove docker-selinux
       sudo yum -y install ntpdate net-tools
       sudo ntpdate -s time.nist.gov
       sudo cp /vagrant/scripts/install_ee.sh .
       sudo chmod +x install_ee.sh
       ./install_ee.sh
       sudo hostname -I | awk '{print $2}' > /vagrant/centos-dtr-node1
     SHELL
    end

    # Docker EE node for CentOS 7.3
    config.vm.define "worker-node1" do |centos_worker_node1|
      disk = '../vagrant-disks/vagrant-disk5.vdi'
      centos_worker_node1.vm.box = "centos/7"
      centos_worker_node1.vm.network "private_network", ip: "172.28.128.35"
      centos_worker_node1.landrush.tld = 'local'
      centos_worker_node1.vm.hostname = "worker-node1.local"
      centos_worker_node1.landrush.enabled = true
      centos_worker_node1.vm.provider :virtualbox do |vb|
        unless File.exist?(disk)
          vb.customize ['createhd', '--filename', disk, '--variant', 'Fixed', '--size', 20 * 1024]
        end
        vb.customize ['storageattach', :id,  '--storagectl', 'IDE', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', disk]
        vb.customize ["modifyvm", :id, "--memory", "2048"]
        vb.customize ["modifyvm", :id, "--cpus", "2"]
        vb.name = "centos-worker-node1"
      end
      centos_worker_node1.vm.provision "shell", inline: <<-SHELL
       sudo yum -y remove docker
       sudo yum -y remove docker-selinux
       sudo yum -y install ntpdate net-tools
       sudo ntpdate -s time.nist.gov
       sudo cp /vagrant/scripts/install_ee.sh .
       sudo chmod +x install_ee.sh
       ./install_ee.sh
     SHELL
    end

end
