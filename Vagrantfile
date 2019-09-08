Vagrant.configure("2") do |config|
  config.ssh.insert_key = false  
  NodeCount = 2
   (1..NodeCount).each do |i|
	 config.vm.define "raven#{i}" do |node|			
			setup(node, "#{i}")
		end
	end
   
  config.vm.provision "shell", path: "install.sh" 
  config.vm.synced_folder ".", "/vagrant"
end

def setup(r1, index)
	
	r1.vm.box = "generic/ubuntu1804"	
	r1.vm.network "private_network", ip: "192.168.43.1" + index
	r1.vm.hostname = "raven" + index + ".mooo.com"
	r1.vm.provider "virtualbox" do |vb|
		vb.name = "raven"+index;
		vb.memory = "1024"
	end
end

