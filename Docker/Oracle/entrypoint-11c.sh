#!/bin/bash

export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe
export ORACLE_SID=XE
export PATH=$ORACLE_HOME/bin:$PATH

SETUP_SCRIPTS_DIR=${SETUP_SCRIPTS_DIR:-/u01/app/oracle/scripts/setup}
SETUP_CONNECT=${SETUP_CONNECT:-/ as sysdba}
SETUP_TIMEOUT=${SETUP_TIMEOUT:-600}

READY_MARKER=/home/finished.log
: > "$READY_MARKER" 2>/dev/null

/entrypoint.sh "$@" &
oracle_pid=$!

shutdown() {
    kill -TERM "$oracle_pid" 2>/dev/null
    wait "$oracle_pid"
    exit 0
}
trap shutdown INT TERM

instance_is_open() {
    sqlplus -S -L / as sysdba <<'SQL' 2>&1 | grep -q OPEN
set pagesize 0 feedback off heading off
select status from v$instance;
exit;
SQL
}

ready=no
waited=0
while [ "$waited" -lt "$SETUP_TIMEOUT" ]; do
    if grep -q 'Database ready to use' "$READY_MARKER" 2>/dev/null && instance_is_open; then
        ready=yes
        break
    fi
    if ! kill -0 "$oracle_pid" 2>/dev/null; then
        echo "(!) /entrypoint.sh exited before the database was ready"
        wait "$oracle_pid"
        exit 1
    fi
    sleep 5
    waited=$((waited + 5))
done

if [ "$ready" != yes ]; then
    echo "(!) database still not ready after ${SETUP_TIMEOUT}s, setup skipped"
    wait "$oracle_pid"
    exit $?
fi

if ! lsnrctl status >/dev/null 2>&1; then
    echo "(*) Listener is down after startup, starting it"
    lsnrctl start
    # PMON registers services on its own schedule, up to a minute later
    sqlplus -S -L / as sysdba >/dev/null <<'SQL'
alter system register;
exit;
SQL
fi

if [ -n "${ORACLE_PWD:-}" ]; then
    echo "(*) Setting SYS and SYSTEM passwords from ORACLE_PWD"
    sqlplus -S -L / as sysdba >/dev/null <<SQL
alter user sys identified by "$ORACLE_PWD";
alter user system identified by "$ORACLE_PWD";
exit;
SQL
fi

shopt -s nullglob
failed=0
for script in "$SETUP_SCRIPTS_DIR"/*.sql; do
    echo "(*) Applying $script"
    out=$(sqlplus -S -L $SETUP_CONNECT <<SQL 2>&1
set define off
set sqlblanklines on
set echo off
@$script
exit;
SQL
)
    [ -n "$out" ] && printf '%s\n' "$out"
    if printf '%s\n' "$out" | grep -qE '(ORA|SP2|PLS)-[0-9]{4,5}'; then
        echo "(!) $script reported errors"
        failed=$((failed + 1))
    fi
done

if [ "$failed" -gt 0 ]; then
    echo "(!) $failed setup script(s) reported errors"
fi
echo "(*) Setup finished"

wait "$oracle_pid"