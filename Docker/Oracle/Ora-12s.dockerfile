FROM oracle:12.2.0.1-neworiginal
USER root

RUN sed -i \
      -e 's/^createAsContainerDatabase=.*/createAsContainerDatabase=false/' \
      -e 's/^numberOfPDBs=.*/numberOfPDBs=0/' \
      -e 's/^pdbName=/#pdbName=/' \
      -e 's/^pdbAdminPassword=/#pdbAdminPassword=/' \
      -e '/^totalMemory=/d' \
      /opt/oracle/dbca.rsp.tmpl \
 && sed -i \
      -e '/ALTER PLUGGABLE DATABASE .*SAVE STATE;/d' \
      -e '/EXEC DBMS_XDB_CONFIG.SETGLOBALPORTENABLED/d' \
      /opt/oracle/createDB.sh \
 && sed -i \
      -E 's/(FROM v\\+\$)pdbs/\1database/' \
      /opt/oracle/checkDBStatus.sh

RUN usermod -u 1000 oracle
RUN chown -R oracle:oracle /opt/oracle
RUN chmod -R 771 /opt/oracle/scripts/setup


USER oracle

ENV ORACLE_SID=ORCL \
    ORACLE_CHARACTERSET=AL32UTF8

EXPOSE 1521 5500

WORKDIR /opt/oracle/scripts/setup

HEALTHCHECK --interval=30s --timeout=10s --start-period=5m --retries=5 \
  CMD sqlplus -L sys/${ORACLE_PWD}@//localhost:1521/${ORACLE_SID} as sysdba <<< "select 1 from dual;" || exit 1