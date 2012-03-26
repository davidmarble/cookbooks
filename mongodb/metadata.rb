maintainer        "David Marble"
maintainer_email  "davidmarble@gmail.com"
license           "MIT"
name              "mongodb"
description       "mongodb recipes"
version           "0.1.0"

recipe            "mongodb", ""
    
%w{ debian ubuntu centos redhat }.each do |os|
  supports os
end