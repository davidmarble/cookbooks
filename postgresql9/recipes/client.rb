include_recipe "postgresql9::repo"

case node['platform']
when "ubuntu","debian"
    pg_packages = %w{postgresql-client libpq-dev}
when "fedora","suse","amazon"
    pg_packages = %w{postgresql-devel}
when "redhat","centos","scientific"
    if node['platform_version'].to_f >= 6.0
        pg_packages = %w{postgresql-devel}
    else
        # libpqxx-devel
        pg_packages = ["postgresql#{node[:postgresql9][:version].split('.').join}-devel"]
    end
end

pg_packages.each do |pg_pack|
    package pg_pack do
        action :install
    end
end

case node['platform']
when "ubuntu","debian"
    template "/etc/profile.d/postgresql.sh" do
        source "debian.bashrc_postgres.erb"
        owner "root"
        group "root"
        mode 0755
    end
when "redhat","centos","scientific"
    template "/etc/profile.d/postgresql.sh" do
        source "redhat.bashrc_postgres.erb"
        owner "root"
        group "root"
        mode 0755
    end
end        
