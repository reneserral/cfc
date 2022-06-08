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
    nftables.vm.hostname = "nftables"
    # nftables.vm.network :private_network, ip: "192.168.38.11"
    nftables.vm.provision "shell", inline: <<-SHELL
      apt update
      apt upgrade -y
      apt install -qy git systemd-timesyncd curl gnupg2 nginx
      curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | apt-key add -
      echo "deb https://packages.wazuh.com/4.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list
      apt-get update
      # WAZUH_MANAGER="192.168.38.10" apt-get install wazuh-agent
      systemctl daemon-reload
      # systemctl enable wazuh-agent
      # systemctl start wazuh-agent
      echo "<html><head><title>${HOSTNAME}</title></head>" \
           "<body><h1>${HOSTNAME}</h1>" \
           "<p>This is the default web page for ${HOSTNAME}.</p>" \
           "<img src='images/image1.gif'/></body></html>" \
          | sudo tee /var/www/html/index.html
      SHELL
  end

  config.vm.define :web_extra, primary: true do |web_extra|
    web_extra.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024", "--cpus", "1"]
    end
    web_extra.vm.box = "debian/bullseye64"
    web_extra.vm.hostname = "webextra"
    # web_extra.vm.network :private_network, ip: "192.168.38.14"
    web_extra.vm.provision "shell", inline: <<-SHELL
      apt update
      apt upgrade -y
      apt install -qy git systemd-timesyncd curl gnupg2 nginx
      curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | apt-key add -
      echo "deb https://packages.wazuh.com/4.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list
      apt-get update
      # WAZUH_MANAGER="192.168.38.10" apt-get install wazuh-agent
      systemctl daemon-reload
      # systemctl enable wazuh-agent
      # systemctl start wazuh-agent
      echo "<html><head><title>${HOSTNAME}</title></head>" \
           "<body><h1>${HOSTNAME}</h1>" \
           "<p>This is the default web page for ${HOSTNAME}.</p>" \
           "<img src='images/image1.gif'/></body></html>" \
          | sudo tee /var/www/html/index.html
      SHELL
  end


  config.vm.define :image_server, primary: true do |image_server|
    image_server.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024", "--cpus", "1"]
    end
    image_server.vm.box = "debian/bullseye64"
    image_server.vm.hostname = "imageserver"
    # image_server.vm.network :private_network, ip: "192.168.38.12"
    image_server.vm.provision "shell", inline: <<-SHELL
      apt update
      apt upgrade -y
      apt install -qy git systemd-timesyncd curl gnupg2 nginx
      curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | apt-key add -
      echo "deb https://packages.wazuh.com/4.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list
      apt-get update
      # WAZUH_MANAGER="192.168.38.10" apt-get install wazuh-agent
      systemctl daemon-reload
      # systemctl enable wazuh-agent
      # systemctl start wazuh-agent
      mkdir /var/www/html/images
      wget https://github.com/reneserral/cfc/raw/main/haproxy/keyboard.gif -O/var/www/html/images/image1.gif
      SHELL
  end

  config.vm.define :haproxy, primary: true do |haproxy|
    haproxy.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024", "--cpus", "1"]
    end
    haproxy.vm.box = "debian/bullseye64"
    haproxy.vm.hostname = "haproxy"
    # haproxy.vm.network :private_network, ip: "192.168.38.13"
    haproxy.vm.network :forwarded_port, guest: 80, host: 8081
    haproxy.vm.network :forwarded_port, guest: 8080, host: 8080
    haproxy.vm.network :forwarded_port, guest: 443, host: 8082

    haproxy.vm.provision "shell", inline: <<-SHELL
      apt update
      apt upgrade -y
      apt install -qy git systemd-timesyncd curl gnupg2 haproxy
      curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | apt-key add -
      echo "deb https://packages.wazuh.com/4.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list
      apt-get update
      # WAZUH_MANAGER="192.168.38.10" apt-get install wazuh-agent
      systemctl daemon-reload
      # systemctl enable wazuh-agent
      # systemctl start wazuh-agent
      SHELL
  end

  config.vm.define :wazuh do |wazuh|
    wazuh.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "4096", "--cpus", "2"]
      vb.customize ["storageattach", :id, 
                  "--storagectl", "IDE", 
                  "--port", "0", "--device", "1", 
                  "--type", "dvddrive", 
                  "--medium", "emptydrive"] 
    end

    wazuh.vm.hostname = "wazuh"
    # wazuh.vm.network :private_network, ip: "192.168.38.10"
    wazuh.vm.box = "uahccre/wazuh-manager"
  end
end

