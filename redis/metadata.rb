maintainer        "David Marble"
maintainer_email  "davidmarble@gmail.com"
license           "Apache 2.0"
name              "redis"
description       "redis recipes"
version           "0.1.0"

recipe            "redis", ""
    
%w{ debian ubuntu centos redhat }.each do |os|
  supports os
end