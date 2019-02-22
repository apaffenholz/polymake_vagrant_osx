# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'json'
require 'time'

ENV["LC_ALL"] = "en_US.UTF-8"

# get basic data: ip. ports, names
data        = JSON.parse(File.read("resources/osx_data.json"))

# the types of vm we define, currently plain, brew, fink
types       = data["types"]

# the os version we support, currently 10,11,12
os_versions = data["os_versions"]

# check which repo we should use, polymake.org or github
# the default is polymake.org, can be changed by passing the variable REPO=github to vagrant up
repo   = ENV["REPO"] || "polymake"

# check which branch we should check out
# default is master, can be changed by passing BRANCH=branchname to grant up
branch = ENV["BRANCH"] || "master"

if ENV["BREW_BASE"] 
   brew_base = ENV["BREW_BASE"]
end

# determine whether we should compile dependencies, only evaluated for type "plain"
compile_dependencies = ENV["COMPILE_DEPENDENCIES"] || 1

# determine whether we should compile polymake
compile_polymake = ENV['COMPILE_POLYMAKE'] || 1

# the directory the polymake sources are checked out to
polymake_src_dir = "data/src/" + repo

#check status of repo
if Dir.exists? polymake_src_dir
   Dir.chdir(polymake_src_dir) do 
      git_return = `git status`
      /On branch (?<true_branch>.*)\s/ =~ git_return
      /working directory (?<clean>.*)\s/ =~ git_return
      
      if branch != true_branch && clean != "clean" 
         puts "branch switch requested but working directory not clean, please commit first"
         exit
      else 
         system "git checkout " + branch
      end
      if clean == "clean"
         system "git pull > /dev/null"
      end
   end
end

Vagrant.configure(2) do |config|
   
   # configure machine
   config.vm.provider "virtualbox" do |v|
      v.memory = data["memory"]
      v.cpus = data["cores"]
   v.gui = false
   end

   # fix time on machine
   # necessary for build tools to work!
   # get offset in hours
   offset_in_h = ((Time.zone_offset(Time.now.zone) / 60) / 60)
   
   # which direction?
   timezone_suffix = offset_in_h >= 0 ? "-#{offset_in_h.to_s}" : "+#{offset_in_h.to_s}"
   
   #prepare time zone string
   timezone = 'Etc/GMT' + timezone_suffix
   config.vm.provision :shell, :inline => "sudo rm /etc/localtime && sudo ln -s /usr/share/zoneinfo/" + timezone + " /etc/localtime", run: "always"
   config.nfs.map_uid = 502
   config.nfs.map_gid = 20
   config.ssh.forward_agent="yes"

   # now define all machines by type and version
   (0..types.length-1).each do |j|
      type = types[j]
      os_versions.each do |i|
         config.vm.define "osx.#{i}.#{type}" do |node|

#            if i == 13 
#               node.vm.box              = "osx-10.13b"
#               node.vm.base_mac = "0800273129DC"
#            else 
               node.vm.box              = "osx-10.#{i}"
#            end
            machine_name             = "osx.#{i}.#{type}"
            node.vm.box_check_update = false

            # set ports and ip
            ssh_port     = data["host_ssh_port_base"] + 10 * (i - os_versions[0]) + j
            http_port    = data["host_http_port_base"] + 10 * (i - os_versions[0]) + j
            jupyter_port = data["host_jupyter_port_base"] + 10 * (i - os_versions[0]) + j
            ip           = "192.168." + (33 + j).to_s + ".#{i}"
            if i == 11 
               if type == "brew"
                  ip = "192.168.50.100"
               end
            end

            # port forwarding and ip
            node.vm.network :forwarded_port, guest:   22, host: ssh_port
            node.vm.network :forwarded_port, guest:   80, host: http_port
            node.vm.network :forwarded_port, guest: 8888, host: jupyter_port
            node.vm.network :private_network, ip: ip
            
            # disable standard share
            node.vm.synced_folder ".", "/vagrant", disabled: true
            
            # define share to data subfolder
            node.vm.synced_folder data["data_source"],   "/data",  type: "nfs", map_uid: 502
            node.vm.synced_folder data["shared_source"], "/share", type: "nfs", map_uid: 502

            # install java
            node.vm.provision :shell, :path => "resources/install_java.sh", :args => data['jdk_version'], :name => "install_java"

            # install tex
            node.vm.provision :shell, :path => "resources/install_tex.sh", :args => data['tex_version'], :name => "install_tex"
            
            # set message of the day to report ip, type, version, repo, branch and ports of the machine
            node.vm.provision :shell, :inline => "/data/scripts/motd.sh 'ssh port' #{ssh_port} 'http_port' #{http_port} 'jupyter_port' #{jupyter_port} 'type' #{type} 'version' #{i} 'repo' #{repo} 'branch' #{branch}", :name => "install_motd"
            
            # add host key of polymake.org
            node.vm.provision "shell" do |s|
               s.inline = "/data/scripts/add_known_hosts.sh"
               s.privileged = false
               s.name = "add_known_hosts"
            end

            node.vm.provision "shell", inline: "echo \"export CCACHE_DIR=/share/#{machine_name}/ccache\" >> /etc/profile", run: "always"

            if i == 14
               node.vm.provision :shell, :path => "resources/install_SDK_headers_10.14.sh", :name => "SDK headers"
            end
            node.vm.provision "shell" do |s|
            
               s.inline = "/data/scripts/install_ccache.sh " + machine_name + " " + data['ccache']['pkg_name']
               s.name = "install ccache"
               s.privileged=false
            end

            # now prepare base system for brew or fink
            case type
               when "brew"
                  node.vm.provision "shell" do |s|
                     full_args = ""
                     if brew_base
                        full_args = brew_base
                     end
                     s.inline = "/data/scripts/brew_base_system.sh " + full_args
                     s.privileged = false
                  end
               when "fink"
                  node.vm.provision :shell, :path => "resources/install_xquartz.sh", :args => data['xquartz_version']
                  node.vm.provision :shell, :inline => "mkdir -p /Users/vagrant/Downloads"
                  full_args = " " + data["type"]["fink"]["fink_base"] + " " + data["type"]["fink"]["fink_version"] + " " + data["type"]["fink"]["fink_install_tool_name"]
                  node.vm.provision "shell" do |s|
                     s.inline = "/data/scripts/fink_base_system.sh " + full_args 
                     s.privileged = false
                  end
               when "bundle"
                  node.vm.provision :shell, :path => "resources/install_python.sh", :args => [ data['python']['version'], data['python']['pkg_name'] ]
                  node.vm.provision "shell" do |s|
                     s.inline = "/data/scripts/polymake_bundle_prepare.sh"
                     s.privileged = false
                  end
            end
            
            # install dependencies for polymake
            if compile_dependencies == 1
               case type
                  when "brew"
                     full_args = ""
                     if brew_base
                        full_args += " -p " + brew_base
                     end
                     node.vm.provision "shell" do |s|
                        s.inline = "/data/scripts/brew_for_polymake.sh " + full_args
                        s.privileged = false
                     end
                  when "fink"
                     node.vm.provision "shell" do |s|
                        full_args = " -b " + branch + " -r " + repo + " -m " + machine_name
                        s.inline = "/data/scripts/fink_for_polymake.sh" + full_args
                        s.privileged = false
                     end
                     # jupyter needs to be installed as root
                     node.vm.provision "shell" do |s|
                        s.inline = ". /sw/bin/init.sh && pip install jupyter"
                     end
               end
            end

            # install polymake
            if compile_polymake == 1
               case type
                  when "brew"
                     node.vm.provision "shell" do |s|
                        full_args = " -b " + branch + " -r " + repo + " -m " + machine_name
                        s.inline = "/data/scripts/polymake_with_brew.sh " + full_args
                        s.privileged = false
                     end
                  when "fink"
                     node.vm.provision "shell" do |s|
                        s.inline = "/data/scripts/polymake_with_fink.sh " + full_args
                        s.privileged = false
                     end
                  when "plain"
                     full_args = "-b " + branch + " -m " + machine_name + " -r " + repo
                     node.vm.provision "shell" do |s|
                        s.inline = "script -q /dev/null /data/scripts/polymake_plain.sh " + full_args
                        s.privileged = false
                        s.name = "install polymake"
                     end
                  when "bundle"
                     node.vm.provision "shell" do |s|
                        s.inline = "/data/scripts/polymake_bundle_compile.sh"
                        s.privileged = false
                     end
               end
            end
         end
      end
   end
end