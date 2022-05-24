# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  config.vm.define :nftables, primary: true do |nftables|
    nftables.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024", "--cpus", "1"]
    end
    nftables.vm.box = "debian/bullseye64"
    nftables.vm.hostname = "debianbullseye1"
    nftables.vm.network :private_network, ip: "192.168.38.11"
    nftables.vm.provision "shell", inline: <<-SHELL
      apt update
      apt upgrade -y
      apt install -qy git systemd-timesyncd curl gnupg2 nginx
      SHELL
  end

end
