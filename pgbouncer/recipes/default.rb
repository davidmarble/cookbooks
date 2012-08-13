include_recipe "libevent"

# script "Install pgbouncer from source" do
    # interpreter "bash"
    # user "root"
    # cwd Chef::Config[:file_cache_path]
    # code <<-EOH
    # wget http://pgfoundry.org/frs/download.php/3085/pgbouncer-1.4.2.tgz
    # tar xf pgbouncer-1.4.2.tgz
    # cd pgbouncer-1.4.2
    # ./configure --prefix=/usr/local --with-libevent=/usr/local
    # make
    # make install
    # EOH
# end

package "pgbouncer"

case node['platform']
when "ubuntu","debian"
    user = "postgres"
    group = "root"
when "centos","redhat","fedora","amazon"
    user = "pgbouncer"
    group = "pgbouncer"    
end

script "Check pgbouncer logfile permissions" do
    interpreter "bash"
    user "root"
    code <<-EOH
    touch /var/log/pgbouncer.log
    chown #{user}:#{group} /var/log/pgbouncer.log
    chmod 0600 /var/log/pgbouncer.log
    EOH
end

directory "/etc/pgbouncer/" do
    owner "#{user}"
    group "#{group}"
    recursive true
    mode 0755
end

service "pgbouncer" do
    supports :restart => true, :reload => true
    action :enable
end

template "/etc/default/pgbouncer" do
    source "etc/default/pgbouncer.erb"
    owner "#{user}"
    group "root"
    mode 0644
    notifies :reload, resources(:service => "pgbouncer")
end

template "/etc/pgbouncer/pgbouncer.ini" do
    source "etc/pgbouncer/pgbouncer.ini.erb"
    owner "#{user}"
    group "root"
    mode 0644
    notifies :reload, resources(:service => "pgbouncer")
end

template "/etc/pgbouncer/userlist.txt" do
    source "etc/pgbouncer/userlist.txt.erb"
    owner "#{user}"
    group "root"
    mode 0644
    notifies :reload, resources(:service => "pgbouncer")
end

case node.platform
when "redhat", "centos", "fedora"
    execute "sudo /sbin/service pgbouncer start" do
        not_if "pgrep -f pgbouncer"
    end
when "debian", "ubuntu"
    execute "sudo /etc/init.d/pgbouncer start" do
        not_if "pgrep -f pgbouncer"
    end
end

