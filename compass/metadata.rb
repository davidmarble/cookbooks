maintainer        "David Marble"
maintainer_email  "davidmarble@gmail.com"
license           "MIT"
name              "compass"
description       "compass recipes"
version           "0.1.0"

recipe            "compass", ""
    
%w{ debian ubuntu centos redhat }.each do |os|
  supports os
end