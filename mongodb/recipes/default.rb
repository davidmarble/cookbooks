# Sets up the repositories for stable 10gen packages found here:
# http://www.mongodb.org/downloads#packages

case node['platform']
when "debian", "ubuntu"
    # Adds the repo: http://www.mongodb.org/display/DOCS/Ubuntu+and+Debian+packages
    execute "apt-get update" do
        action :nothing
    end

    if node['platform'] == "ubuntu"
        apt_repository "10gen" do
            uri "http://downloads-distro.mongodb.org/repo/ubuntu-upstart"
            distribution "dist"
            components ["10gen"]
            keyserver "keyserver.ubuntu.com"
            key "7F0CEB10"
            action :add
            notifies :run, "execute[apt-get update]", :immediately
        end
    else
        apt_repository "10gen" do
            uri "http://downloads-distro.mongodb.org/repo/debian-sysvinit"
            distribution "dist"
            components ["10gen"]
            keyserver "keyserver.ubuntu.com"
            key "7F0CEB10"
            action :add
            notifies :run, "execute[apt-get update]", :immediately
        end
    end

    package "mongodb-10gen"
    
    service "mongodb" do
        supports :status => true, :restart => true
        action [:enable, :start]
    end
    
    template "/etc/mongodb.conf" do
        source "debian.mongodb.conf.erb"
        owner "mongodb"
        group "mongodb"
        mode 0644
        notifies :restart, resources(:service => "mongodb"), :immediately
    end
    
when "redhat", "centos"
    # http://www.mongodb.org/display/DOCS/CentOS+and+Fedora+Packages
    cookbook_file "/etc/yum.repos.d/10gen.repo" do
        source "10gen.repo"
        owner "root"
        group "root"
        mode 0644
    end

    package "mongo-10gen"
    package "mongo-10gen-server"
    
    service "mongod" do
        supports :status => true, :restart => true
        action [:enable, :start]
    end
    
    template "/etc/mongod.conf" do
        source "redhat.mongod.conf.erb"
        owner "mongod"
        group "mongod"
        mode 0644
        notifies :restart, resources(:service => "mongod"), :immediately
    end
end

case node.platform
when "redhat", "centos", "fedora"
    execute "sudo /sbin/service mongod start" do
        not_if "pgrep -f mongod"
    end
when "debian", "ubuntu"
    execute "sudo /etc/init.d/mongodb start" do
        not_if "pgrep -f mongodb"
    end
end
