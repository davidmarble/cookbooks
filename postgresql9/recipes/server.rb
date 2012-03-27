case node.platform
when "redhat", "centos"
    node[:postgresql9][:dir] = "/var/lib/pgsql/#{node[:postgresql9][:version]}/data"
    node[:postgresql9][:contrib] = "/usr/pgsql-#{node[:postgresql9][:version]}/share/contrib/"
when "debian", "ubuntu"
    node[:postgresql9][:dir] = "/etc/postgresql/#{node[:postgresql9][:version]}/main"
    node[:postgresql9][:contrib] = "/usr/share/postgresql/#{node[:postgresql9][:version]}/contrib"
end

if node[:postgresql9][:version].to_f == 9.1

    if node.platform == 'ubuntu' and node[:platform_version].to_f == 11.10
        execute "apt-get update" do
            action :run
        end

        package "postgresql-#{node[:postgresql9][:version]}"
        package "postgresql-server-dev-#{node[:postgresql9][:version]}"
        package "postgresql-contrib-#{node[:postgresql9][:version]}"
        
        if node[:postgresql9][:extras].include?('postgis')
            package "postgresql-#{node[:postgresql9][:version]}-postgis"
            package "proj"
            package "libgeos-3.2.2"
            package "libgeos-c1"
            package "libgeos-dev"
            package "libgdal1-1.7.0"
            package "libgdal1-dev"
        end

        service "postgresql" do
            enabled true
            running true
            supports :status => true, :restart => true, :reload => true
            action [:enable, :start]
        end
        
        template "#{node[:postgresql9][:dir]}/postgresql.conf" do
          source "debian.postgresql.conf.erb"
          owner "postgres"
          group "postgres"
          mode 0600
          notifies :restart, resources(:service => "postgresql"), :immediately
        end
        
        cookbook_file "/var/lib/postgresql/.bash_profile" do
            source "bash_profile_postgres"
            owner "postgres"
            group "postgres"
            mode 0644
        end

        template "/var/lib/postgresql/.bashrc" do
            source "debian.bashrc_postgres.erb"
            owner "postgres"
            group "postgres"
            mode 0600
        end
        
        template "/etc/profile.d/postgresql.sh" do
            source "debian.postgresql.sh"
            owner "root"
            group "root"
            mode 0755
        end
        
    # http://yum.postgresql.org/repopackages.php
    # You may get libpq errors. See  http://stackoverflow.com/questions/4707401/pg-config-ruby-pg-postgresql-9-0-problem-after-upgrade-centos-5
    elsif ['centos'].include?(node.platform) and node['platform_version'].to_f < 6
        user "postgres" do
            shell "/bin/bash"
            comment "PostgreSQL Server"
            home "/var/lib/pgsql"
            system true
            supports :manage_home => false
        end
        
        group "postgres" do
            members ["postgres"]
        end

        # Make sure compat-postgresql-libs is NOT installed
        package "compat-postgresql-libs" do
            action :remove
        end
        package "postgresql91"
        package "postgresql91-server"
        package "postgresql91-libs"
        package "postgresql91-contrib"
        package "postgresql91-devel"
        
        if node[:postgresql9][:extras].include?('postgis')
            package "postgis91"
            package "postgis91-utils"
            package "proj-devel"
            package "geos-devel"
        end
        
        execute "ln -s /etc/init.d/postgresql-9.1 /etc/init.d/postgresql" do
            not_if { ::FileTest.exist?("/etc/init.d/postgresql") }
        end
        
        execute "/sbin/service postgresql initdb" do
            not_if { ::FileTest.exist?(File.join(node[:postgresql9][:dir], node[:postgresql9][:version])) }
        end

        service "postgresql" do
            supports :restart => true, :status => true, :reload => true
            action [:enable, :start]
        end

        template "#{node[:postgresql9][:dir]}/postgresql.conf" do
            source "redhat.postgresql.conf.erb"
            owner "postgres"
            group "postgres"
            mode 0600
            notifies :restart, resources(:service => "postgresql"), :immediately
        end
        
        cookbook_file "/var/lib/pgsql/.bash_profile" do
            source "bash_profile_postgres"
            owner "postgres"
            group "postgres"
            mode 0644
        end

        template "/var/lib/pgsql/.bashrc" do
            source "redhat.bashrc_postgres.erb"
            owner "postgres"
            group "postgres"
            mode 0600
        end
        
        template "/etc/profile.d/postgresql.sh" do
            source "redhat.postgresql.sh"
            owner "root"
            group "root"
            mode 0755
        end
        
    else
        # TODO: Build from source
        
    end
    
    template "#{node[:postgresql9][:dir]}/pg_hba.conf" do
        source "pg_hba.conf.erb"
        owner "postgres"
        group "postgres"
        mode 0644
        notifies :restart, resources(:service => "postgresql"), :immediately
    end
    
    if node[:postgresql9][:extras].include?("postgis")
        # Some packages on redhat/centos don't have this file
        cookbook_file "#{node[:postgresql9][:contrib]}/postgis-1.5/postgis_comments.sql" do
            source "postgis_comments.sql"
            owner "root"
            group "root"
            mode "0755"
            action :create_if_missing
        end
    
        script "Create and setup template_postgis database" do
            interpreter "bash"
            user "postgres"
            code <<-EOH
createdb -E UTF8 template_postgis
createlang -d template_postgis plpgsql 2>&-
psql -q -d template_postgis -f #{node[:postgresql9][:contrib]}/postgis-1.5/postgis.sql
psql -q -d template_postgis -f #{node[:postgresql9][:contrib]}/postgis-1.5/spatial_ref_sys.sql
psql -q -d template_postgis -f #{node[:postgresql9][:contrib]}/postgis-1.5/postgis_comments.sql
psql -q -d template_postgis -c "UPDATE pg_database SET datistemplate=TRUE WHERE datname='template_postgis';"
psql -q -d template_postgis -c "REVOKE ALL ON SCHEMA public FROM public;"
psql -q -d template_postgis -c "GRANT USAGE ON SCHEMA public TO public;"
psql -q -d template_postgis -c "GRANT ALL ON SCHEMA public TO postgres;"
psql -q -d template_postgis -c "GRANT ALL on geometry_columns TO PUBLIC;"
psql -q -d template_postgis -c "GRANT ALL ON geography_columns TO PUBLIC;"
psql -q -d template_postgis -c "GRANT ALL ON spatial_ref_sys TO PUBLIC;"
psql -q -d template_postgis -c "VACUUM FULL;"
psql -q -d template_postgis -c "VACUUM FREEZE;"
psql -q -d template_postgis -c "UPDATE pg_database SET datallowconn=FALSE WHERE datname='template_postgis';"
            EOH
            not_if "psql -l | grep template_postgis", :user => "postgres"
            only_if "pgrep -lf postgres"
        end
    end
end

if node[:postgresql9].attribute?("createdb")
    include_recipe "postgresql9::createdb"
end
