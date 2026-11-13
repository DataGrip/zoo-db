FROM registry.jetbrains.team/p/datagrip/containers/oracle:12.2.0.1-e-orig
# https://github.com/oracle/docker-images/blob/main/OracleDatabase/SingleInstance/dockerfiles/12.2.0.1/Dockerfile

USER root

# createDB.sh removes totalMemory=2048 on hosts with more than 8 CPUs and
# lets DBCA size memory from host RAM. Keep it within the container's 5 GiB limit.
RUN sed -i -e 's/^totalMemory=.*/totalMemory=4096/' /opt/oracle/dbca.rsp.tmpl

USER oracle

ENV ORACLE_BASE=/opt/oracle \
    ORACLE_SID=ORCLCDB \
    ORACLE_CHARACTERSET=AL32UTF8

HEALTHCHECK --interval=30s --timeout=10s --start-period=5m --retries=5 \
  CMD sqlplus -L sys/${ORACLE_PWD}@//localhost:1521/${ORACLE_SID} as sysdba <<< "select 1 from dual;" || exit 1
