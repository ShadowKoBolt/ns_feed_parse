# vim: set ft=ruby :

Vagrant.configure('2') do |config|

  config.vm.box = 'ShadowKoBolt/ubuntu-precise'

  config.vm.hostname = 'nsfeedparse'
  config.vm.network :private_network, ip: '192.168.69.28'

  config.vm.synced_folder '~', '/home/master'
  config.vm.synced_folder '.', '/home/vagrant/source'

  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--cpus', '1', '--memory', 1024]
  end

  config.vm.provision :ansible do |ansible|
    ansible.playbook = 'playbook.yml'
  end

end
