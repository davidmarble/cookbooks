maintainer        "David Marble"
maintainer_email  "davidmarble@gmail.com"
license           "MIT"
name              "ghostscript"
description       "ghostscript recipes"
version           "0.1.0"

recipe            "ghostscript", ""
    
%w{ debian ubuntu centos redhat }.each do |os|
  supports os
end