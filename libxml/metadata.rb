maintainer        "David Marble"
maintainer_email  "davidmarble@gmail.com"
license           "MIT"
description       "libxml2"
version           "0.1.0"

recipe            "libxml", "install libxml2"
    
%w{ ubuntu debian centos redhat fedora }.each do |os|
  supports os
end
