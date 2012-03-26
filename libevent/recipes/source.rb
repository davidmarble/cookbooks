libevent_version = node[:libevent][:version]

# Remove any installed packages
case node.platform
when "debian", "ubuntu"
    package "libevent-dev" do
        action :remove
    end
when "redhat", "centos", "fedora"
    package "libevent-devel" do
        action :remove
    end
end

# Install libevent
script "Install libevent from source" do
    interpreter "bash"
    user "root"
    cwd "/tmp"
    code <<-EOH
    wget --no-check-certificate https://github.com/downloads/libevent/libevent/libevent-#{libevent_version}-stable.tar.gz
    tar xvfz libevent-#{libevent_version}-stable.tar.gz
    cd libevent-#{libevent_version}-stable
    ./configure --prefix=/usr/local
    make
    make install
    EOH
end

