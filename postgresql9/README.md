# Warning

This cookbook only covers (at the moment):

* PostgreSQL 9.1 on Ubuntu 11.10
* PostgreSQL 9.1 on CentOS/RHEL 5.x

# Description

Install, configure, and run PostgreSQL 9 (http://www.postgresql.org/), 
an open source transactional relational database engine.

This was named postgresql9 because it had too many changes and is too 
ugly at this point to try to merge with the Opscode postgresql cookbook.

# Requirements

* PostgreSQL must be installed already (`postgres` user and group must exist) 

# Usage

In your chef configuration, you must define keys to populate the postgresql 
configuration files. See `templates/` for the actual files. Here is an example 
configuration in JSON that installs PostgreSQL with PostGIS enabled, limits 
connections to MD5 authentication on the 10.0.0.0 network, and 
specifies a database to be created with the PostGIS template:

    "postgresql9": {
        "version": "9.1",
        "listen": "listen_addresses = '*'",
        "auth": ["host    all             all             10.0.0.0/24          md5"],
        "extras": ["postgis"],
        "createdb" : {
            "1": {
                "name": "exampledb",
                "user": "exampleuser",
                "password": "strong-password",
                "template": "-T template_postgis"
            }
        }
    },


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
