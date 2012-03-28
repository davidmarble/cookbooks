#
# libxml2
#

case node.platform
when "redhat", "centos"
    package "libxml2"
    package "libxml2-devel"
    package "libxslt"
    package "libxslt-devel"
when "debian", "ubuntu"
    # if node.platform == 'ubuntu' and node['platform_version'].to_f == 11.10
    execute "apt-get update" do
        action :run
    end
    package "libxml2"
    package "libxml2-dev"
    package "libxslt1.1"
    package "libxslt1-dev"
    # end
end
