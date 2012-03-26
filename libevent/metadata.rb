maintainer        "David Marble"
maintainer_email  "davidmarble@gmail.com"
license           "MIT"
name              "libevent"
description       "libevent recipes"
version           "0.1.0"

recipe            "libevent", ""
    
%w{ debian ubuntu centos redhat }.each do |os|
  supports os
end