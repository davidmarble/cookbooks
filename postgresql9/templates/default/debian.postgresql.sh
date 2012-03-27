if ! echo ${PGDATA} | /bin/grep -q /<%= node.postgresql9.version -%>/data ; then 
PGDATA=/var/lib/pgsql/<%= node.postgresql9.version -%>/data
fi

if ! echo ${PATH} | /bin/grep -q /pgsql-<%= node.postgresql9.version -%>/bin ; then 
PATH=$PATH:/usr/pgsql-<%= node.postgresql9.version -%>/bin
fi

if ! echo ${LD_LIBRARY_PATH} | /bin/grep -q /<%= node.postgresql9.version -%>/lib ; then 
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/postgresql/<%= node.postgresql9.version -%>/lib
fi