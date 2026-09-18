#!/bin/bash
set -e
/opt/mssql/bin/sqlservr &

MSSQL_PID=$!

# Wait until server starts
echo "Waiting for SQL Server to start..."
until /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -C -Q "SELECT 1;" &> /dev/null
do
  echo "SQL Server is starting up... "
  sleep 5
done
echo "SQL Server started successfully"

# Running SQL-scripts
jq -r '."Ms-15"[]' scripts.json | while read -r script; do
  /opt/mssql-tools18/bin/sqlcmd -S localhost -U SA -P $MSSQL_SA_PASSWORD -C -i "$script"
  echo "$script executed"
done

wait $MSSQL_PID
