#
# Node.js
#
# For github SSL issues, either of:
#git config --global http.sslverify false
#export GIT_SSL_NO_VERIFY=true

case node.platform
when "redhat", "centos"
    if node['platform_version'].to_f >= 6
        script "Add node.js repo" do
            interpreter "bash"
            user "root"
            cwd Chef::Config[:file_cache_path]
            code <<-EOH
            curl http://nodejs.tchol.org/stable/el6/nodejs-stable.repo > /etc/yum.repos.d/nodejs-stable.repo
            EOH
            not_if { File.exists?("/etc/yum.repos.d/nodejs-stable.repo") }
        end
        
        package "nodejs"
    else # No repo yet for el5
        script "Install Node" do
            interpreter "bash"
            user "root"
            cwd Chef::Config[:file_cache_path]
            code <<-EOH
            wget http://nodejs.org/dist/#{node[:nodejs][:version]}/node-#{node[:nodejs][:version]}.tar.gz
            tar zxf node-#{node[:nodejs][:version]}.tar.gz
            cd node-#{node[:nodejs][:version]}
            ./configure --prefix=/usr/local
            make && make install
            EOH
            not_if "which node"
            # git config --global http.sslverify false
            # git clone https://github.com/joyent/node.git
            # cd node
            # git checkout #{node[:nodejs][:version]}
            # export JOBS=2
            # ./configure --prefix=/usr/local
            # make install            
        end
    end
when "debian", "ubuntu"
    package "python-software-properties"
    # apt_repository "node" do
        # uri "http://ppa.launchpad.net/chris-lea/node.js/ubuntu"
        # distribution "natty"
        # components ["main"]
        # keyserver "keyserver.ubuntu.com"
        # key "C7917B12"
        # action :add
    # end
    script "Add node.js repo" do
        interpreter "bash"
        user "root"
        cwd Chef::Config[:file_cache_path]
        code <<-EOH
        add-apt-repository ppa:chris-lea/node.js
        EOH
        not_if "grep \"chris-lea/node\" /etc/apt/sources.list"
    end

    execute "apt-get update" do
        action :run
    end

    package "nodejs"
end

#
# NPM
#
# script "Install NPM" do
    # interpreter "bash"
    # user "root"
    # cwd Chef::Config[:file_cache_path]
    # code <<-EOH
    # git config --global http.sslverify false
    # git clone git://github.com/isaacs/npm.git
    # cd npm
    # make install
    # EOH
    # not_if "which npm"
# end

package "curl"

execute "curl http://npmjs.org/install.sh | clean=yes sh" do
    not_if "which npm"
end
