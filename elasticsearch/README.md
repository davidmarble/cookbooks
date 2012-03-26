# DESCRIPTION:

Installs and configures ElasticSearch on a single machine. 

This cookbook was stripped and mostly re-written from Grant Rodgers' 
cookbook for GoTime, Inc. For an alternative more advanced cookbook, see 
https://github.com/infochimps-cookbooks/elasticsearch

# REQUIREMENTS:

##  Platform:

Tested on CentOS 5.7. Preliminary work done for Ubuntu, but not yet tested.

## Cookbooks:

* Opscode's `java` cookbook. https://github.com/opscode-cookbooks/java
* Opscode's `git` cookbook. https://github.com/opscode-cookbooks/git
* davidmarble's `utils` cookbook. https://github.com/davidmarble/cookbook-utils

# ATTRIBUTES:

The only important attribute at present is the version. It's currently set to:

    default[:elasticsearch][:version] = "0.19.1"

See attributes/default.rb for more.

Default attributes place files as below:

/opt/elasticsearch-<version>: program files
/opt/elasticsearch: link to the most recently built version
/etc/elasticsearch: configuration files
/var/lib/elasticsearch: elasticsearch data files
/var/log/elasticsearch: elasticsearch log directory


# LICENSE and AUTHOR:

Author:: Grant Rodgers (<grant@gotime.com>)

Copyright:: 2010, GoTime Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

