#
# 0MQ Setup
# Try this later: https://github.com/pyronicide/zeromq-cookbook
#
include_recipe "build-essential"

packages = value_for_platform(
    ["centos","redhat","fedora"] => {'default' => ['automake', 'libtool', 'uuid-devel']},
    "default" => ['libtool', 'uuid-dev']
  )

packages.each do |devpkg|
  package devpkg
end

case node.platform
when "redhat", "centos", "fedora"
    # From source
    script "Install ZeroMQ from source" do
        interpreter "bash"
        user "root"
        cwd Chef::Config[:file_cache_path]
        code <<-EOH
        wget http://download.zeromq.org/zeromq-2.1.11.tar.gz 
        tar zxf zeromq-2.1.11.tar.gz
        cd zeromq-2.1.11
        ./autogen.sh
        ./configure --with-pgm --prefix=/usr
        make 
        make install
        ldconfig
        EOH
        not_if { ::FileTest.exists?("/usr/lib/libzmq.so") }
    end
when "debian", "ubuntu"
    package "python-software-properties"

    # apt_repository "zeromq" do
        # uri "http://ppa.launchpad.net/chris-lea/zeromq/ubuntu"
        # distribution "natty"
        # components ["main"]
        # keyserver "keyserver.ubuntu.com"
        # key "C7917B12"
        # action :add
    # end

    # script "Add zeromq repositories" do
        # interpreter "bash"
        # user "root"
        # cwd "/tmp/"
        # code <<-EOH
        # add-apt-repository -y ppa:chris-lea/libpgm
        # add-apt-repository -y ppa:chris-lea/zeromq
        # EOH
        # not_if "ls /etc/apt/sources.list.d | grep 'chris-lea-zeromq'"
    # end

    execute "apt-get update" do
        action :run
    end

    package "libzmq1"
    package "libzmq-dbg"
    package "libzmq-dev"
end
