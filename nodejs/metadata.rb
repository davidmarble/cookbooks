maintainer        "David Marble"
maintainer_email  "davidmarble@gmail.com"
license           "MIT"
name              "nodejs"
description       "nodejs recipes"
version           "0.1.0"

recipe            "nodejs", ""
    
%w{ debian ubuntu centos redhat }.each do |os|
  supports os
end