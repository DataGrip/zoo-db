FROM registry.jetbrains.team/p/datagrip/containers/oracle:21.3-xe-orig

USER root

RUN sed -i -e 's/^totalMemory=.*/totalMemory=4096/' /opt/oracle/product/21c/dbhomeXE/assistants/dbca/dbca.rsp

RUN sed -i -e 's/^if \[ \$(id -u) != "0" \]$/if false/' /etc/init.d/oracle-xe-21c \
 && grep -q '^if false$' /etc/init.d/oracle-xe-21c

# createDB.sh sed's this file directly (outside $SU) while configuring XE
RUN chown oracle:oinstall /etc/sysconfig/oracle-xe-21c.conf \
 && chmod 664 /etc/sysconfig/oracle-xe-21c.conf

RUN sed -i -e "s|su -c '/etc/init.d/oracle-xe-21c start'|/etc/init.d/oracle-xe-21c start|" \
      /opt/oracle/runOracle.sh \
 && grep -q "^\s*/etc/init.d/oracle-xe-21c start\$" /opt/oracle/runOracle.sh

RUN sed -i \
      -e 's|su -c "sed -i|sed -i|' \
      -e 's|su -c "/etc/init.d/oracle-xe-21c configure << EOF$|/etc/init.d/oracle-xe-21c configure << EOF|' \
      /opt/oracle/createDB.sh \
 && grep -q '^\s*sed -i' /opt/oracle/createDB.sh \
 && grep -q '^\s*/etc/init.d/oracle-xe-21c configure' /opt/oracle/createDB.sh

ADD ./su-as-self.sh /usr/local/bin/su-as-self
RUN chmod 755 /usr/local/bin/su-as-self
ENV SU=/usr/local/bin/su-as-self

USER oracle

ENV ORACLE_BASE=/opt/oracle \
    ORACLE_CHARACTERSET=AL32UTF8

HEALTHCHECK --interval=30s --timeout=10s --start-period=5m --retries=5 \
  CMD sqlplus -L sys/${ORACLE_PWD}@//localhost:1521/${ORACLE_SID} as sysdba <<< "select 1 from dual;" || exit 1
