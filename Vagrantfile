# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  # official Ubuntu 14.04 Server build
  config.vm.box = "ubuntu/trusty64"

  # for access to PHP web viewer
  config.vm.network "forwarded_port", guest: 80, host: 8080

  # shell script installs dependencies and sets up MySQL
  config.vm.provision "shell", path: "setup.sh"
end
