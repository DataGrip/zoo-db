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
jq -r '."Ms-16"[]' scripts.json | while read -r script; do
  /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P $MSSQL_SA_PASSWORD -C -i "$script"
  echo "$script executed"
done
#/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -C -i "/scripts/create-All-16.sql"

# Checking the tables and users are created
#if /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -C \
#    -d Menagerie -Q "SELECT 1 FROM Zoo.Basic_01_Table;" &>/dev/null; then
#    echo "Table 'Basic_01_Table' exists"
#else
#    echo "Table 'Basic_01_Table' does not exist"
#fi
#
#if /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -C \
#    -Q "SELECT name FROM sys.server_principals WHERE name = 'Curator';" | grep -i "Curator" > /dev/null; then
#    echo "User 'Curator' exists"
#else
#    echo "User 'Curator' does not exist"
#fi

# Waiting for the main process
wait $MSSQL_PID
