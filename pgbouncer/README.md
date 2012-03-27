# Description

Install, configure, and run pgbouncer (http://pgfoundry.org/projects/pgbouncer/), 
a lightweight connection pooler for PostgreSQL.

# Requirements

* PostgreSQL must be installed already (`postgres` user and group must exist) 
* Cookbook: libevent (see https://github.com/davidmarble/cookbooks/tree/master/libevent)

# Usage

Make sure to rename this repo to pgbouncer if you clone it directly 
or use it in a project as a git submodule.

In your chef configuration, you must define keys to populate the pgbouncer 
configuration files. See `templates/` for the actual files. Here is an example 
configuration in JSON:

    "pgbouncer": {
        "databases": "* = port=5432 dbname=example host=127.0.0.1",
        "user": "pguser",
        "password": "super-complex-password",
        "admin_users": "postgres",
        "stats_users": "postgres,pguser"
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
