if node[:postgresql9][:version].to_f == 9.1
    if ['centos'].include?(node.platform) and node['platform_version'].to_f < 6
        script "Add postgresql repo" do
            interpreter "bash"
            user "root"
            cwd "/tmp/"
            code <<-EOH
            if ! /bin/grep -q exclude=postgresql /etc/yum.repos.d/CentOS-Base.repo; then
                sed -i -r 's/KEY-CentOS-5/KEY-CentOS-5\nexclude=postgresql*/g' /etc/yum.repos.d/CentOS-Base.repo
                if ! [ -f /etc/yum.repos.d/pgdg-91-centos.repo ]; then
                    cd /tmp
                    wget http://yum.postgresql.org/9.1/redhat/rhel-5-x86_64/pgdg-centos91-9.1-4.noarch.rpm
                    rpm -ivh pgdg-centos91-9.1-4.noarch.rpm
                fi
            fi
            EOH
        end
    end
end
