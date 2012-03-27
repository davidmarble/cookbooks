# Description

Chef cookbook for installing ZeroMQ (http://www.zeromq.org/).

**NOTE:** Make sure to rename this to `zeromq` if you clone it or incorporate 
it as a git submodule in your cookbooks.

# Requirements

## Cookbooks

* **build-essential**

# Usage

## Recipes

### zeromq

Simply include "zeromq" in your run list to install the ZeroMQ libraries.

On Redhat/CentOS, the recipe builds ZeroMQ from source. 

On Debian/Ubuntu, the recipe installs the distribution binary libraries.

# License and Author

Author:: David Marble (<davidmarble@gmail.com>)

Copyright:: 2012, David Marble

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
