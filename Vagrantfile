Vagrant.configure("2") do |config|
config.vm.provision "shell", path: "kubernetes-node.sh"

  config.vm.box = "centos/7"


   config.vm.network "public_network", ip: "10.5.120.124"


end
