redis_version = node[:redis][:version]

case node.platform
when "redhat", "centos", "fedora", "suse"
    have_redis_ver = `redis-cli --version 2>&- | grep -q #{redis_version}`
    if 0 == have_redis_ver.length
        
        # Stop to compile
        begin
            service "redis-server" do
                action :stop
            end
        rescue
        end
    
        script "Download and install redis #{redis_version}" do
            interpreter "bash"
            user "root"
            cwd Chef::Config[:file_cache_path]
            code <<-EOH
            wget http://redis.googlecode.com/files/redis-#{redis_version}.tar.gz
            tar xzf redis-#{redis_version}.tar.gz
            cd redis-#{redis_version}
            make install
            EOH
        end
        
        cookbook_file "/etc/init.d/redis-server" do
            source "etc/init.d/redis-server.redhat"
            owner "root"
            group "root"
            mode "0755"
            action :create_if_missing
        end
    end
    
when "debian", "ubuntu"
    package "python-software-properties"

    script "Add redis repository" do
        interpreter "bash"
        user "root"
        cwd Chef::Config[:file_cache_path]
        code <<-EOH
        add-apt-repository ppa:rwky/redis
        EOH
        not_if "ls /etc/apt/sources.list.d | grep 'rwky-redis'"
    end

    execute "apt-get update" do
        action :run
    end

    package "redis-server"
    
    cookbook_file "/etc/init.d/redis-server" do
        source "etc/init.d/redis-server.debian"
        owner "root"
        group "root"
        mode "0755"
        action :create_if_missing
    end
    
end

daemonize = node[:redis][:daemonize]

directory "/etc/redis/" do
    owner "root"
    group "root"
    mode 0755
end

if daemonize == "yes"
    service "redis-server" do
        supports :restart => true, :reload => true
        action :enable
    end

    template "/etc/redis/redis.conf" do
        source "etc/redis/redis.conf.erb"
        owner "root"
        group "root"
        mode 0644
        notifies :restart, resources(:service => "redis-server"), :immediately
    end

    case node.platform
    when "redhat", "centos", "fedora"
        execute "sudo /sbin/service redis-server start" do
            not_if "pgrep -f redis-server"
        end
    when "debian", "ubuntu"
        execute "sudo /etc/init.d/redis-server start" do
            not_if "pgrep -f redis-server"
        end
    end
else
    begin
        service "redis-server" do
            action :disable
        end
    rescue
    end
    
    template "/etc/redis/redis.conf" do
        source "etc/redis/redis.conf.erb"
        owner "root"
        group "root"
        mode 0644
    end
end

# script "Stop redis if running" do
    # interpreter "bash"
    # user "root"
    # code <<-EOH
    # pkill -KILL -f 'redis'
    # EOH
    # only_if "pgrep -lf 'redis'"
# end

# script "Don't start redis-server at startup part 1" do
    # interpreter "bash"
    # user "root"
    # cwd "/etc/init"
    # code <<-EOH
	# service redis-server stop
    # mv redis-server.conf redis-server.conf.off
    # EOH
    # only_if { ::FileTest.exists?("/etc/init/redis-server.conf") }
# end
  
# script "Don't start redis-server at startup part 2" do
    # interpreter "bash"
    # user "root"
    # cwd "/etc/init"
    # code <<-EOH
    # update-rc.d -f redis-server remove
    # mkdir -p /etc/init.d/unused
    # mv /etc/init.d/redis-server /etc/init.d/unused
    # EOH
    # only_if { ::FileTest.exists?("/etc/init.d/redis-server") }
# end

# /sbin/chkconfig --add redis-server
# /sbin/chkconfig --level 345 redis-server on
# /sbin/service redis-server start