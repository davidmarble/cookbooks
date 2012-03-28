# Credit to GoTime for their original recipe 
# (http://cookbooks.opscode.com/cookbooks/elasticsearch).

# NOTE: head takes a LONG time to build

# David Marble - customizations:
# * requires utils_ensure_user from https://github.com/davidmarble/cookbook-utils
# * No runit dependency
# * Program files in /opt by default
# * If newer version defined in config, running this recipe will update to 
#   that version
# * Directories defined in ../attributes/ follow linux conventions

include_recipe "java"
include_recipe "git"
package "wget"

is_head = node[:elasticsearch][:version] == "head"
node[:elasticsearch][:version_home] = "#{node[:elasticsearch][:home_link]}-#{node[:elasticsearch][:version]}"

if is_head
    bash "Clone elasticsearch repo or pull" do
        cwd Chef::Config[:file_cache_path]
        code <<-EOH
        git config --global http.sslverify false
        if ! [ -d elasticsearch-#{node[:elasticsearch][:version]} ]; then
            git clone https://github.com/elasticsearch/elasticsearch.git elasticsearch-#{node[:elasticsearch][:version]}
            cd elasticsearch-#{node[:elasticsearch][:version]} && ./gradlew
        else
            cd elasticsearch-#{node[:elasticsearch][:version]} && git pull && ./gradlew
        fi
        EOH
    end
else
    bash "Get elasticsearch source" do
        cwd Chef::Config[:file_cache_path]
        code <<-EOH
            wget --no-check-certificate https://github.com/downloads/elasticsearch/elasticsearch/elasticsearch-#{node[:elasticsearch][:version]}.tar.gz
            tar zxf elasticsearch-#{node[:elasticsearch][:version]}.tar.gz
        EOH
        not_if { File.exists? "#{Chef::Config[:file_cache_path]}/elasticsearch-#{node[:elasticsearch][:version]}" }
    end
end

utils_ensure_user "elasticsearch" do
    system true
    update_if_exists false
end

[
    node[:elasticsearch][:version_home],
    "#{node[:elasticsearch][:version_home]}/plugins",
    node[:elasticsearch][:path_conf]
].each do |dir|
    directory dir do
        owner "root"
        group "root"
        recursive true
        mode 0755
    end
end

[
    node[:elasticsearch][:path_logs], 
    node[:elasticsearch][:path_run],
    node[:elasticsearch][:path_data],
    node[:elasticsearch][:path_work]
].each do |dir|
    directory dir do
        owner "elasticsearch"
        group "elasticsearch"
        recursive true
        mode 0755
    end
end

# Get service repo
bash "Clone elasticsearch-serviewrapper repo or pull" do
    cwd Chef::Config[:file_cache_path]
    code <<-EOH
    git config --global http.sslverify false
    if ! [ -d elasticsearch-servicewrapper ]; then
        git clone https://github.com/infopark/elasticsearch-servicewrapper.git
    else
        cd elasticsearch-servicewrapper && git pull
    fi
    EOH
end


# case node.platform
# when "redhat", "centos"
    # template "/etc/init.d/elasticsearch" do
        # source "redhat.elasticsearch.erb"
        # mode 0755
    # end
# when "debian", "ubuntu"
    # template "/etc/init.d/elasticsearch" do
        # source "debian.elasticsearch.erb"
        # mode 0755
    # end
# end

readlink = `readlink -q -e #{node[:elasticsearch][:home_link]}`.chomp.strip
is_same_link = node[:elasticsearch][:version_home] == readlink

if is_head or !is_same_link or !File.exists? "#{node[:elasticsearch][:version_home]}/lib"
    begin
        service "elasticsearch" do
            action [:stop, :disable]
        end
    rescue
    end

    bash "copy elasticsearch root" do
        user "root"
        cwd Chef::Config[:file_cache_path]
        code %(cp -r #{Chef::Config[:file_cache_path]}/elasticsearch-#{node[:elasticsearch][:version]}/* #{node[:elasticsearch][:version_home]})
    end

    link node[:elasticsearch][:home_link] do
        to node[:elasticsearch][:version_home]
    end
    
    # \cp to get around limitations of root having the alias cp=cp -i 
    bash "Copy and enable elasticsearch-servicewrapper" do
        cwd node[:elasticsearch][:version_home]
        code <<-EOH
        if [ -d #{node[:elasticsearch][:version_home]}/bin/service ]; then
            rm -rf #{node[:elasticsearch][:version_home]}/bin/service
        fi
        cp -r #{Chef::Config[:file_cache_path]}/elasticsearch-servicewrapper/service #{node[:elasticsearch][:version_home]}/bin/
        if [ -f /etc/init.d/elasticsearch ]; then
            bin/service/elasticsearch remove
        fi
        bin/service/elasticsearch install
        EOH
    end    
end

# cookbook_file "#{node[:elasticsearch][:home_link]}/bin/elasticsearch" do
    # source "elasticsearch"
    # mode 0775
    # notifies :run, "script[restart-elasticsearch]"
# end

service "elasticsearch" do
    supports :status => true, :restart => true
    action :enable
end

template "#{node[:elasticsearch][:path_conf]}/wrapper.conf" do
    source "elasticsearch.conf.erb"
    owner "elasticsearch"
    group "elasticsearch"
    mode 0644
    notifies :run, "script[restart-elasticsearch]"
end

# template "#{node[:elasticsearch][:home_link]}/bin/service/elasticsearch.conf" do
    # source "elasticsearch.conf.erb"
    # owner "elasticsearch"
    # group "elasticsearch"
    # mode 0644
    # notifies :run, "script[restart-elasticsearch]"
# end

template "#{node[:elasticsearch][:path_conf]}/logging.yml" do
    source "logging.yml.erb"
    owner "elasticsearch"
    group "elasticsearch"
    mode 0644
    notifies :run, "script[restart-elasticsearch]"
end

template "#{node[:elasticsearch][:home_link]}/elasticsearch.in.sh" do
    source "elasticsearch.in.sh.erb"
    owner "elasticsearch"
    group "elasticsearch"
    mode 0755
    notifies :run, "script[restart-elasticsearch]"
end

template "#{node[:elasticsearch][:path_conf]}/elasticsearch.yml" do
    source "elasticsearch.yml.erb"
    owner "elasticsearch"
    group "elasticsearch"
    mode 0600
    notifies :run, "script[restart-elasticsearch]"
end

script "start elasticsearch if not running" do
    interpreter "bash"
    user "root"
    code <<-EOH
    nohup /etc/init.d/elasticsearch start >/tmp/elasticsearch-start1.log 2>&1 &
    EOH
    not_if "pgrep -f elasticsearch"
end

script "restart-elasticsearch" do
    interpreter "bash"
    user "root"
    code <<-EOH
    if pgrep -f elasticsearch; then
        nohup /etc/init.d/elasticsearch restart >/tmp/elasticsearch-start2.log 2>&1 &
    else
        nohup /etc/init.d/elasticsearch start >/tmp/elasticsearch-start2.log 2>&1 &
    fi
    EOH
    action :nothing
end

