# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  config.vm.define :nftables, primary: true do |nftables|
    nftables.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "4096", "--cpus", "2"]
    end
    nftables.vm.box = "debian/bullseye64"
    nftables.vm.hostname = "nftables"
    nftables.vm.network :private_network, ip: "192.168.56.11"
    #nftables.vm.network :forwarded_port, guest: 8080, host: 8080
    nftables.vm.provision "shell", inline: <<-SHELL
      apt update
      apt upgrade -y
      apt install -qy git systemd-timesyncd curl gnupg2 nginx
      curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | apt-key add -
      echo "deb https://packages.wazuh.com/4.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list
      apt-get update
      WAZUH_MANAGER="192.168.56.10" apt-get install wazuh-agent
      systemctl daemon-reload
      systemctl enable wazuh-agent
      systemctl start wazuh-agent
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
    web_extra.vm.network :private_network, ip: "192.168.56.14"
    web_extra.vm.provision "shell", inline: <<-SHELL
      apt update
      apt upgrade -y
      apt install -qy git systemd-timesyncd curl gnupg2 nginx
      curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | apt-key add -
      echo "deb https://packages.wazuh.com/4.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list
      apt-get update
      WAZUH_MANAGER="192.168.56.10" apt-get install wazuh-agent
      systemctl daemon-reload
      systemctl enable wazuh-agent
      systemctl start wazuh-agent
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
    image_server.vm.network :private_network, ip: "192.168.56.12"
    image_server.vm.provision "shell", inline: <<-SHELL
      apt update
      apt upgrade -y
      apt install -qy git systemd-timesyncd curl gnupg2 nginx
      curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | apt-key add -
      echo "deb https://packages.wazuh.com/4.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list
      apt-get update
      WAZUH_MANAGER="192.168.56.10" apt-get install wazuh-agent
      systemctl daemon-reload
      systemctl enable wazuh-agent
      systemctl start wazuh-agent
      mkdir /var/www/html/images
      wget https://github.com/reneserral/cfc/raw/main/haproxy/keyboard.gif -O/var/www/html/images/image1.gif
      SHELL
  end

  config.vm.define :john, primary: true do |john|
    john.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024", "--cpus", "1"]
    end
    john.vm.box = "debian/bullseye64"
    john.vm.hostname = "john"
    john.vm.network :private_network, ip: "192.168.56.12"
    john.vm.provision "shell", inline: <<-SHELL
      apt update
      apt upgrade -y
      apt install -qy git systemd-timesyncd curl gnupg2 nginx
      echo Installing John The Ripper 1.9.0 Jumbo Bleeding Edge
      wget 'https://github.com/reneserral/cfc/blob/main/john/john-1.9.0-jumbo-1+bleeding.tar.bz2?raw=true' -q -O - | sudo tar -C / -xjf -
      SHELL
  end

  config.vm.define :haproxy, primary: true do |haproxy|
    haproxy.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024", "--cpus", "1"]
    end
    haproxy.vm.box = "debian/bullseye64"
    haproxy.vm.hostname = "haproxy"
    haproxy.vm.network :private_network, ip: "192.168.56.13"
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
      WAZUH_MANAGER="192.168.56.10" apt-get install wazuh-agent
      systemctl daemon-reload
      systemctl enable wazuh-agent
      systemctl start wazuh-agent
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
    wazuh.vm.network :private_network, ip: "192.168.56.10"
    wazuh.vm.box = "uahccre/wazuh-manager"
  end

  config.vm.define :windows10 do |windows10|
    windows10.vm.provider :virtualbox do |vb|
      vb.customize ['modifyvm', :id, '--usb', 'on']
      vb.customize ["modifyvm", :id, "--usbehci", "on"]
      vb.customize ["modifyvm", :id, "--memory", "2048", "--cpus", "2"]
    end
    windows10.vm.hostname = "windows10"
    windows10.vm.network :private_network, ip: "192.168.56.21"
    windows10.vm.box = "peru/windows-10-enterprise-x64-eval"
    windows10.vm.provision "shell", path: "https://raw.githubusercontent.com/rene-serral/monitoring-course/main/Modulo-2/Configure-base.bat"
  end
  config.vm.define :windows2022 do |windows2022|
    windows2022.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048", "--cpus", "2"]
    end
    windows2022.vm.hostname = "windows"
    windows2022.vm.network :private_network, ip: "192.168.56.20"
    windows2022.vm.box = "peru/windows-server-2022-standard-x64-eval"
    windows2022.vm.box_version = "20210907.01"
    windows2022.vm.provision "shell", path: "https://raw.githubusercontent.com/rene-serral/monitoring-course/main/Modulo-2/Configure-base.bat"
  end

  config.vm.define :kali, primary: true do |kali|
    kali.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048", "--cpus", "2"]
    end
    kali.vm.box = "kalilinux/rolling"
    kali.vm.hostname = "kali"
    kali.vm.network :private_network, ip: "192.168.56.15"
    kali.vm.provision "shell", inline: <<-SHELL
      useradd kali -m -p $(openssl passwd -6 kali123)
      apt update
      apt upgrade -y
      apt install -qy git systemd-timesyncd curl gnupg2
      setxkbmap -layout es
    SHELL
  end

end

