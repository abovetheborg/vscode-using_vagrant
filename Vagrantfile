Vagrant.configure("2") do |config|
        config.vm.define "supertimor" do |node|
            node.vm.box = "ubuntu/focal64"
            node.vm.hostname = "supertimor"
            node.vm.network :private_network, ip: "168.198.58.58"
            node.vm.network "forwarded_port", guest: 22, host: 22, id: "ssh"
            node.vm.boot_timeout = 300
            # See VS Code Requirement (which I assumed are also the requirement to run the VS Code Server): https://code.visualstudio.com/docs/supporting/requirements
            node.vm.provider :virtualbox do |vb|
                vb.customize ["modifyvm", :id, "--memory", 4096]
                vb.customize ["modifyvm", :id, "--cpus", 1]
            end  # do node.vm.provider
			node.vm.provision "file", source: "~/.ssh/keys_for_linux_vm_dev/code_on_linux_from_windows_addendum_authorize_keys.pub", destination: "/tmp/provision/temp_pub_key.pub"
            node.vm.provision "file", source: "~/.ssh/keys_for_linux_vm_dev/vm_key_for_gitbuh.openssh_private", destination: "/tmp/provision/temp_private_key_for_github"
			node.vm.provision "shell", path: "bin/vagrant_provision.sh"
        end # config.vm.define
    
end # Vagrant.configure