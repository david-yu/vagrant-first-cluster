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
    config.vm.define "centos-ucp-node1" do |centos_ucp_node1|
      disk = './vagrant-disk.vdi'
      centos_ucp_node1.vm.box = "centos/7"
      centos_ucp_node1.vm.network "private_network", type: "dhcp"
      centos_ucp_node1.vm.hostname = "centos-ucp-node1"
      config.vm.provider :virtualbox do |vb|
        unless File.exist?(disk)
          vb.customize ['createhd', '--filename', disk, '--variant', 'Fixed', '--size', 20 * 1024]
        end
        vb.customize ['storageattach', :id,  '--storagectl', 'IDE', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', disk]
        vb.customize ["modifyvm", :id, "--memory", "2048"]
        vb.customize ["modifyvm", :id, "--cpus", "2"]
        vb.name = "centos-ucp-node1"
      end
      centos_ucp_node1.vm.provision "shell", inline: <<-SHELL
        sudo yum -y remove docker
        sudo yum -y remove docker-selinux
        sudo yum -y install ntpdate
        sudo ntpdate -s time.nist.gov
     SHELL
    end

    # Docker EE node for CentOS 7.3
    config.vm.define "centos-ucp-node2" do |centos_ucp_node2|
      disk = './vagrant-disk2.vdi'
      centos_ucp_node2.vm.box = "centos/7"
      centos_ucp_node2.vm.network "private_network", type: "dhcp"
      centos_ucp_node2.vm.hostname = "centos-ucp-node2"
      unless File.exist?(disk)
        vb.customize ['createhd', '--filename', disk, '--variant', 'Fixed', '--size', 20 * 1024]
      end
      config.vm.provider :virtualbox do |vb|
        vb.customize ['storageattach', :id,  '--storagectl', 'IDE', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', disk]
        vb.customize ["modifyvm", :id, "--memory", "2048"]
        vb.customize ["modifyvm", :id, "--cpus", "2"]
        vb.name = "centos-ucp-node2"
      end
      centos_ucp_node2.vm.provision "shell", inline: <<-SHELL
        sudo yum -y remove docker
        sudo yum -y remove docker-selinux
        sudo yum -y install ntpdate
        sudo ntpdate -s time.nist.gov
      SHELL
    end

    # Docker EE node for CentOS 7.3
    config.vm.define "centos-ucp-node3" do |centos_ucp_node3|
      disk = './vagrant-disk3.vdi'
      centos_ucp_node3.vm.box = "centos/7"
      centos_ucp_node3.vm.network "private_network", type: "dhcp"
      centos_ucp_node3.vm.hostname = "centos-ucp-node3"
      unless File.exist?(disk)
        vb.customize ['createhd', '--filename', disk, '--variant', 'Fixed', '--size', 20 * 1024]
      end
      config.vm.provider :virtualbox do |vb|
        vb.customize ['storageattach', :id,  '--storagectl', 'IDE', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', disk]
        vb.customize ["modifyvm", :id, "--memory", "2048"]
        vb.customize ["modifyvm", :id, "--cpus", "2"]
        vb.name = "centos-ucp-node3"
      end
      centos_ucp_node3.vm.provision "shell", inline: <<-SHELL
       sudo yum -y remove docker
       sudo yum -y remove docker-selinux
       sudo ntpdate -s time.nist.gov
     SHELL
    end

    # Docker EE node for CentOS 7.3
    config.vm.define "centos-dtr-node1" do |centos_dtr_node1|
      disk = './vagrant-disk4.vdi'
      centos_dtr_node1.vm.box = "centos/7"
      centos_dtr_node1.vm.network "private_network", type: "dhcp"
      centos_dtr_node1.vm.hostname = "centos-dtr-node1"
      unless File.exist?(disk)
        vb.customize ['createhd', '--filename', disk, '--variant', 'Fixed', '--size', 20 * 1024]
      end
      config.vm.provider :virtualbox do |vb|
        vb.customize ['storageattach', :id,  '--storagectl', 'IDE', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', disk]
        vb.customize ["modifyvm", :id, "--memory", "2048"]
        vb.customize ["modifyvm", :id, "--cpus", "2"]
        vb.name = "centos-dtr-node1"
      end
      centos_dtr_node1.vm.provision "shell", inline: <<-SHELL
       sudo yum -y remove docker
       sudo yum -y remove docker-selinux
       sudo ntpdate -s time.nist.gov
     SHELL
    end

    # Docker EE node for CentOS 7.3
    config.vm.define "centos-worker-node1" do |centos_worker_node1|
      disk = './vagrant-disk5.vdi'
      centos_worker_node1.vm.box = "centos/7"
      centos_worker_node1.vm.network "private_network", type: "dhcp"
      centos_worker_node1.vm.hostname = "centos-worker-node1"
      unless File.exist?(disk)
        vb.customize ['createhd', '--filename', disk, '--variant', 'Fixed', '--size', 20 * 1024]
      end
      config.vm.provider :virtualbox do |vb|
        vb.customize ['storageattach', :id,  '--storagectl', 'IDE', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', disk]
        vb.customize ["modifyvm", :id, "--memory", "2048"]
        vb.customize ["modifyvm", :id, "--cpus", "2"]
        vb.name = "centos-worker-node1"
      end
      centos_worker_node1.vm.provision "shell", inline: <<-SHELL
       sudo yum -y remove docker
       sudo yum -y remove docker-selinux
       sudo ntpdate -s time.nist.gov
     SHELL
    end

end
