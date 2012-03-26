# DESCRIPTION:

Installs and configures MongoDB.

* 10gen repository package installation
* Single MongoDB instance

# REQUIREMENTS:

## Platform:

CentOS, Redhat, Ubuntu, Debian

# ATTRIBUTES:

* `mongodb[:port]` - Port the mongod listens on, default is 27017

# USAGE:

## Single mongodb instance

```ruby
include_recipe "mongodb"
```
