maintainer        "David Marble"
maintainer_email  "davidmarble@gmail.com"
license           "Apache 2.0"
name              "postgresql9"
description       "Install/Configure Postgresql 9"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.1.0"

# depends           "build-essential"

recipe "postgresql9::repo", "Installs repositories for Postgresql 9."
recipe "postgresql9::client", "Installs Postgresql 9 client."
recipe "postgresql9::server", "Installs Postgresql 9 server."
recipe "postgresql9::createdb", "Creates database."
recipe "postgresql9", "Installs repositories and Postgresql 9 server."

%w{ debian ubuntu centos redhat fedora freebsd }.each do |os|
  supports os
end
