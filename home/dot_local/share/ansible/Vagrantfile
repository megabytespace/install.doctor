# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.6.2"

nodes = [
  { :hostname => 'archlinux', :ip => '192.168.14.41', :box => 'Megabyte/Archlinux-Desktop' },
  { :hostname => 'centos', :ip => '192.168.14.42', :box => 'Megabyte/CentOS-Desktop' },
  { :hostname => 'debian', :ip => '192.168.14.43', :box => 'Megabyte/Debian-Desktop' },
  { :hostname => 'fedora', :ip => '192.168.14.44', :box => 'Megabyte/Fedora-Desktop' },
  { :hostname => 'macos', :ip => '192.168.14.45', :box => 'Megabyte/macOS-Desktop', :ram => 8192 },
  { :hostname => 'ubuntu', :ip => '192.168.14.46', :box => 'Megabyte/Ubuntu-Desktop' },
  { :hostname => 'windows', :ip => '192.168.14.47', :box => 'Megabyte/Windows-Desktop', :ram => 4096 }
]

Vagrant.configure("2") do |config|
  nodes.each do |node|
    config.vm.define node[:hostname] do |nodeconfig|
      nodeconfig.vm.box = node[:box]
      nodeconfig.vm.hostname = node[:hostname]

      nodeconfig.vm.network :private_network, ip: node[:ip]
      nodeconfig.vm.network :forwarded_port, guest: 22, host: 52022, id: "ssh", auto_correct: true
      nodeconfig.vm.network :forwarded_port, guest: 80, host: 52080, id: "http", auto_correct: true
      nodeconfig.vm.network :forwarded_port, guest: 443, host: 52443, id: "https", auto_correct: true
      nodeconfig.vm.network :forwarded_port, guest: 3389, host: 53389, id: "rdp", auto_correct: true

      memory = node[:ram] ? node[:ram] : 2048
      nodeconfig.vm.provider :virtualbox do |vb|
        vb.customize [
          "modifyvm", :id,
          "--cpuexecutioncap", "50",
          "--memory", memory.to_s
        ]
      end
    end
  end

  config.vm.provision :ansible do |ansible|
    ansible.playbook = "main.yml"
    ansible.inventory_path = "inventories/vagrant.yml"
  end
end
