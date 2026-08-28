FROM registry.jetbrains.team/p/datagrip/containers/oracle:21.3-xe-orig
USER root

RUN usermod -u 1000 oracle
RUN chown -R oracle:1000 /opt/oracle
RUN chmod -R 771 /opt/oracle/scripts/setup

USER oracle

HEALTHCHECK --interval=30s --timeout=10s --start-period=5m --retries=5 \
  CMD sqlplus -L sys/${ORACLE_PWD}@//localhost:1521/${ORACLE_SID} as sysdba <<< "select 1 from dual;" || exit 1