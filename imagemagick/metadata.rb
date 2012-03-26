maintainer        "David Marble"
maintainer_email  "davidmarble@gmail.com"
license           "MIT"
name              "imagemagick"
description       "imagemagick recipes"
version           "0.1.0"

recipe            "imagemagick", ""
    
%w{ debian ubuntu centos redhat }.each do |os|
  supports os
end