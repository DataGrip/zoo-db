FROM registry.jetbrains.team/p/datagrip/containers/oracle:19.3-e-orig

USER root

RUN sed -i \
      -e 's/^createAsContainerDatabase=.*/createAsContainerDatabase=false/' \
      -e 's/^numberOfPDBs=.*/numberOfPDBs=0/' \
      -e 's/^pdbName=/#pdbName=/' \
      -e 's/^pdbAdminPassword=/#pdbAdminPassword=/' \
      -e 's/^totalMemory=.*/totalMemory=4096/' \
      /opt/oracle/dbca.rsp.tmpl \
 && sed -i \
      -e '/ALTER PLUGGABLE DATABASE .*SAVE STATE;/d' \
      -e '/EXEC DBMS_XDB_CONFIG.SETGLOBALPORTENABLED/d' \
      /opt/oracle/createDB.sh

USER oracle

ENV ORACLE_BASE=/opt/oracle \
    ORACLE_SID=ORCL \
    ORACLE_CHARACTERSET=AL32UTF8

EXPOSE 1521 5500

WORKDIR /opt/oracle/scripts/setup