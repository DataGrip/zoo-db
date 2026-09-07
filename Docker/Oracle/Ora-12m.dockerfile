FROM oracle:12.2.0.1-neworiginal
USER root

USER oracle

ENV ORACLE_BASE=/opt/oracle \
    ORACLE_SID=ORCLCDB \
    ORACLE_CHARACTERSET=AL32UTF8

HEALTHCHECK --interval=30s --timeout=10s --start-period=5m --retries=5 \
  CMD sqlplus -L sys/${ORACLE_PWD}@//localhost:1521/${ORACLE_SID} as sysdba <<< "select 1 from dual;" || exit 1