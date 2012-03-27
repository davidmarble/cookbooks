if ! echo ${PGDATA} | /bin/grep -q /<%= node.postgresql9.version -%>/data ; then 
PGDATA=/var/lib/pgsql/<%= node.postgresql9.version -%>/data
fi

if ! echo ${PATH} | /bin/grep -q /pgsql-<%= node.postgresql9.version -%>/bin ; then 
PATH=$PATH:/usr/pgsql-<%= node.postgresql9.version -%>/bin
fi
