default['postgresql9']['auth'] = [] # default is local only
default['postgresql9']['local_auth'] = "peer"
default['postgresql9']['version'] = "9.1"
default['postgresql9']['listen'] = "listen_addresses = '*'"
default['postgresql9']['port'] = "5432"
default['postgresql9']['max_connections'] = "100"
default['postgresql9']['shared_buffers'] = "32MB"
default['postgresql9']['ssl'] = true
default['postgresql9']['effective_cache_size'] = "128MB"
default['postgresql9']['extras'] = []
