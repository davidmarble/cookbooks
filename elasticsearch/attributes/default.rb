#https://github.com/downloads/elasticsearch/elasticsearch/elasticsearch-0.19.1.tar.gz
default[:elasticsearch][:version] = "0.19.1"
default[:elasticsearch][:cluster_name] = "default"
default[:elasticsearch][:port] = 9200

default[:elasticsearch][:home_link] = "/opt/elasticsearch"
# default[:elasticsearch][:path_logs] = "/opt/elasticsearch/logs"
# default[:elasticsearch][:path_conf] = "/opt/elasticsearch/config"
# default[:elasticsearch][:path_data] = "/opt/elasticsearch/data"
default[:elasticsearch][:path_logs] = "/var/log/elasticsearch"
default[:elasticsearch][:path_conf] = "/etc/elasticsearch"
default[:elasticsearch][:path_data] = "/var/lib/elasticsearch"

default[:elasticsearch][:path_run]  = "/var/run/elasticsearch"
default[:elasticsearch][:path_work] = "/tmp/elasticsearch"

default[:elasticsearch][:ES_MIN_MEM] = 1024
default[:elasticsearch][:ES_MAX_MEM] = 1024

# open files limit (should be 32K or 64K). See /etc/security/limits.conf
default[:elasticsearch][:fd_ulimit] = 65536 

