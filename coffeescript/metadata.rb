maintainer        "David Marble"
maintainer_email  "davidmarble@gmail.com"
license           "MIT"
name              "coffeescript"
description       "coffeescript recipes"
version           "0.1.0"

recipe            "coffeescript", ""
    
%w{ debian ubuntu centos redhat }.each do |os|
  supports os
end