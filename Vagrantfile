# -*- mode: ruby -*-
# vi: set ft=ruby :

target_systems = {
    :ubuntu_1004_32 => {
        :box     => 'lucid32',
        :box_url => 'http://files.vagrantup.com/lucid32.box'
    },
    :ubuntu_1004_64 => {
        :box     => 'lucid64',
        :box_url => 'http://files.vagrantup.com/lucid64.box'
    },
    :ubuntu_1204_64 => {
        :box     => 'precise64',
        :box_url => 'http://files.vagrantup.com/precise64.box'
    },
    :ubuntu_1204_32 => {
        :box     => 'precise32',
        :box_url => 'http://files.vagrantup.com/precise32.box'
    }
}

Vagrant::Config.run do |config|
  target_systems.each do |name, info|
    config.vm.define name do |local|
      local.vm.box = info[:box]
      local.vm.box_url = info[:box_url]

      local.vm.provision :puppet do |puppet|
        puppet.manifests_path = 'spec/fixtures/manifests'
        puppet.module_path    = '..'
        puppet.manifest_file  = 'vagrant.pp'
        puppet.options        = %w{--verbose}
      end
    end
  end
end