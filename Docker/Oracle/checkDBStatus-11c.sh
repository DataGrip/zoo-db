#!/bin/bash

export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe
export ORACLE_SID=XE
export PATH=$ORACLE_HOME/bin:$PATH

status=$(sqlplus -S -L / as sysdba <<'SQL' 2>&1
set pagesize 0 feedback off heading off
select status from v$instance;
exit;
SQL
)

case $status in
    *OPEN*) exit 0 ;;
    *)      echo "$status"; exit 1 ;;
esac

if ! lsnrctl status >/dev/null 2>&1; then
    echo "listener: not running"
    exit 1
fi