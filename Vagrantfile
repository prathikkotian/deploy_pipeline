Vagrant.configure("2") do |config|
		config.vm.define "server" do |vm1|
			vm1.vm.box="bento/ubuntu-16.04"
			vm1.vm.network :private_network, ip: "192.168.56.51"
			vm1.vm.hostname="server.com"
			vm1.vm.network "forwarded_port", guest: 443, host: 8000
			vm1.vm.provision :shell, path: "bootstrap.sh"
		end
		config.vm.define "node" do |vm2|
			vm2.vm.box="bento/ubuntu-16.04"
			vm2.vm.network :private_network, ip: "192.168.56.52"
			vm2.vm.hostname="client.com"
			vm2.vm.network "forwarded_port", guest: 8080, host: 8080
			vm2.vm.provision :shell, path: "bootstrap_node.sh"
		end
end
