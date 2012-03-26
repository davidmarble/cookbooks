case node.platform
when "debian", "ubuntu"
    package "libevent-dev"
when "redhat", "centos", "fedora"
    package "libevent-devel"
end
