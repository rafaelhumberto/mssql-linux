#!/bin/bash
set -eo pipefail

host="$(echo '127.0.0.1')"
user=SA
password=$SA_PASSWORD


args=(
        # force sqlserver to not use the local unix socket (test "external" connectivity)
        -S $host
        -U $user
        -P $password
        -d master
        -Q "set nocount on; select 1"
        -h -1
)

if select="$(/opt/mssql-tools/bin/sqlcmd "${args[@]}")" && [ $select = 1 ]; then
	exit 0
fi
exit 1
