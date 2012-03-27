node[:postgresql9][:createdb].each_pair do |dbnum, db|

    if !db.has_key?("template")
        db[:template] = ""
    end

    script "Ensure database #{db[:name]} exists" do
        interpreter "bash"
        user "postgres"
        code <<-EOH
        createdb #{db[:template]} #{db[:name]}
        EOH
        not_if "psql -l | grep #{db[:name]}", :user => "postgres"
        only_if "pgrep -lf postgres"
    end

    script "Ensure database user #{db[:user]} exists" do
        interpreter "bash"
        user "postgres"
        code <<-EOH
        echo "create user #{db[:user]} with password '#{db[:password]}';" | psql #{db[:name]}
        echo "GRANT ALL ON SCHEMA public TO #{db[:user]};" | psql #{db[:name]} 2>&-
        echo "grant all privileges on database #{db[:name]} to #{db[:user]};" | psql #{db[:name]} 2>&-
        EOH
        not_if "psql -c '\du' | grep #{db[:user]}", :user => "postgres"
        only_if "pgrep -lf postgres"
    end
end