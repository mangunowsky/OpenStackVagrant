VAGRANTFILE_API_VERSION = "2"

require 'yaml'
if File.file?('config.yaml')
  conf = YAML.load_file('config.yaml')
else
  raise "Configuration file 'config.yaml' does not exist."
end

def configure_vm(name, vm, conf)
  vm.hostname = conf["#{name}"] || name
  vm.network :public_network, :bridge => conf['bridge_int'], :use_dhcp_assigned_default_route => true

  vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
  end

  vm.provision "ansible" do |ansible|
    ansible.playbook = "./ansible/openstack.yaml"
  end

end


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = conf['box_name'] || "ubuntu/focal64"

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
    config.cache.synced_folder_opts = {
      owner: "_apt",
      group: "ubuntu",
      mount_options: ["dmode=777", "fmode=666"]
    }
  end

  config.vm.define "devstack", primary: true do |devstack|
    configure_vm("devstack", devstack.vm, conf)
    devstack.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"
    devstack.vm.network "forwarded_port", guest: 6080, host: 6080, host_ip: "127.0.0.1"
    devstack.vm.disk :disk, size: "200GB", primary: true

    config.vm.provider "virtualbox" do |vb|
      vb.memory = "8096"
      vb.name = "openstack"
    end

  end

  config.ssh.forward_agent = true

end