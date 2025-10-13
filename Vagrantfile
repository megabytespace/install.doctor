# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.6.2"

# { :hostname => 'altair', :desc => 'Archlinux', :ip => '192.168.14.41', :box => 'Megabyte/Archlinux-Desktop' },
# 
# { :hostname => 'mira', :desc => 'macOS 13', :ip => '192.168.14.45', :box => 'Beta/macOS-13', :cpus => 4, :ram => 8192 },
# { :hostname => 'wazn', :desc => 'Windows 11', :ip => '192.168.14.47', :box => 'Megabyte/Windows-Desktop', :cpus => 4, :ram => 4096 }

nodes = [
  { :hostname => 'denab', :desc => 'Debian 11', :ip => '192.168.14.43', :box => "bento/debian-12" },
  { :hostname => 'fulu', :desc => 'Fedora 38', :ip => '192.168.14.44', :box => "bento/fedora-38" },
  { :hostname => 'ukdah', :desc => 'Ubuntu 22.04', :ip => '192.168.14.46', :box => "bento/ubuntu-22.04" },
  { :hostname => 'caph', :desc => 'CentOS 9 Stream', :ip => '192.168.14.42', :box => "bento/centos-stream-9" }
]

Vagrant.configure("2") do |config|
  config.vm.provision "install-doctor",
    type: "shell",
    preserve_order: true,
    inline: "bash <(curl -sSL https://install.doctor/start)"

  nodes.each do |node|
    config.ssh.password = "vagrant"
    config.ssh.username = "vagrant"

    config.vm.define node[:hostname] do |nodeconfig|
      nodeconfig.vm.box = node[:box]
      nodeconfig.vm.hostname = node[:hostname]

      nodeconfig.vm.network :private_network, ip: node[:ip]
      nodeconfig.vm.network :forwarded_port, guest: 22, host: 52022, id: "ssh", auto_correct: true
      nodeconfig.vm.network :forwarded_port, guest: 80, host: 52080, id: "http", auto_correct: true
      nodeconfig.vm.network :forwarded_port, guest: 443, host: 52443, id: "https", auto_correct: true
      nodeconfig.vm.network :forwarded_port, guest: 3389, host: 53389, id: "rdp", auto_correct: true

      cpus = node[:cpu] ? node[:cpu] : 2
      memory = node[:ram] ? node[:ram] : 2048

      nodeconfig.vm.provider :hyperv do |v|
        v.cpus = cpus
        v.maxmemory = memory
        v.vmname = node[:desc]
      end

      nodeconfig.vm.provider :virtualbox do |v|
        v.check_guest_additions = true
        v.cpus = cpus
        v.customize [
          "modifyvm", :id,
          "--cpuexecutioncap", "50",
          "--memory", memory.to_s
        ]
        v.customize ["modifyvm", :id, "--accelerate3d", "on"]
        v.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
        v.customize ["modifyvm", :id, "--graphicscontroller", "vmsvga"]
        v.customize ["modifyvm", :id, "--hwvirtex", "on"]
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--vram", "256"]
        v.customize ["setextradata", "global", "GUI/SuppressMessages", "all"]
        v.gui = true
        v.memory = memory
        v.name = node[:desc]
      end

      nodeconfig.vm.provider :parallels do |v|
        v.cpus = cpus
        v.memory = memory
        v.name = node[:desc]
        v.update_guest_tools = true
      end

      nodeconfig.vm.provider :libvirt do |v, override|
        v.cpus = cpus
        v.memory = memory
        # Use WinRM for the default synced folder; or disable it if
        # WinRM is not available. Linux hosts don't support SMB,
        # and Windows guests don't support NFS/9P/rsync
        # Source: https://github.com/Cimpress-MCP/vagrant-winrm-syncedfolders
        if Vagrant.has_plugin?("vagrant-winrm-syncedfolders")
            override.vm.synced_folder ".", "/vagrant", type: "winrm"
        else
            override.vm.synced_folder ".", "/vagrant", disabled: true
        end
        # Enable Hyper-V enlightments - Source: https://blog.wikichoon.com/2014/07/enabling-hyper-v-enlightenments-with-kvm.html
        v.hyperv_feature :name => 'stimer', :state => 'on'
        v.hyperv_feature :name => 'relaxed', :state => 'on'
        v.hyperv_feature :name => 'vapic', :state => 'on'
        v.hyperv_feature :name => 'synic', :state => 'on'
      end

      nodeconfig.vm.provider :vmware_fusion do |v|
        v.gui = true
        v.vmx["ethernet0.virtualDev"] = "vmxnet3"
        v.vmx["gui.fitGuestUsingNativeDisplayResolution"] = "TRUE"
        v.vmx["gui.fullScreenAtPowerOn"] = "TRUE"
        v.vmx["gui.lastPoweredViewMode"] = "fullscreen"
        v.vmx["gui.viewModeAtPowerOn"] = "fullscreen"
        v.vmx["memsize"] = memory.to_s
        v.vmx["mks.enable3d"] = "TRUE"
        v.vmx["mks.forceDiscreteGPU"] = "TRUE"
        v.vmx["numvcpus"] = cpus.to_s
        v.vmx["RemoteDisplay.vnc.enabled"] = "TRUE"
        v.vmx["RemoteDisplay.vnc.port"] = "5900"
        v.vmx["sound.autodetect"] = "TRUE"
        v.vmx["sound.present"] = "TRUE"
        v.vmx["sound.startConnected"] = "TRUE"
      end

      nodeconfig.vm.provider :vmware_workstation do |v|
        v.gui = true
        v.vmx["ethernet0.virtualDev"] = "vmxnet3"
        v.vmx["gui.fitGuestUsingNativeDisplayResolution"] = "TRUE"
        v.vmx["gui.fullScreenAtPowerOn"] = "TRUE"
        v.vmx["gui.lastPoweredViewMode"] = "fullscreen"
        v.vmx["gui.viewModeAtPowerOn"] = "fullscreen"
        v.vmx["memsize"] = memory.to_s
        v.vmx["mks.enable3d"] = "TRUE"
        v.vmx["mks.forceDiscreteGPU"] = "TRUE"
        v.vmx["numvcpus"] = cpus.to_s
        v.vmx["RemoteDisplay.vnc.enabled"] = "TRUE"
        v.vmx["RemoteDisplay.vnc.port"] = "5900"
        v.vmx["sound.autodetect"] = "TRUE"
        v.vmx["sound.present"] = "TRUE"
        v.vmx["sound.startConnected"] = "TRUE"
      end
    end
  end
end
