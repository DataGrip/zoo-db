FROM registry.jetbrains.team/p/datagrip/containers/oracle:11.2.1-modified

USER root

RUN sed -i \
      -e 's/^if \[ .*id -u.* \]$/if false/' \
      -e 's#ps -ef | grep tns | grep oracle#ps -ef | grep [t]nslsnr#' \
      /etc/init.d/oracle-xe \
 && grep -q '^if false$' /etc/init.d/oracle-xe \
 && grep -q 'grep \[t\]nslsnr' /etc/init.d/oracle-xe

ADD ./su-as-self.sh /usr/local/bin/su-as-self
RUN chmod 755 /usr/local/bin/su-as-self
ENV SU=/usr/local/bin/su-as-self

RUN mkdir -p /etc/profile.d /etc/default /var/lock/subsys \
 && touch /etc/profile.d/oracle-xe.sh /etc/oratab /home/finished.log \
 && chown oracle:dba /etc/profile.d/oracle-xe.sh /etc/oratab /home /home/finished.log /var/lock/subsys \
 && chmod 664 /etc/profile.d/oracle-xe.sh /etc/oratab /home/finished.log \
 && chown root:dba /etc/default && chmod 775 /etc/default \
 && mkdir -p /var/tmp/.oracle && chmod 1777 /var/tmp/.oracle

RUN mkdir -p /scripts && chown oracle:dba /scripts
ENV SETUP_SCRIPTS_DIR=/scripts

ADD ./entrypoint-11c.sh /
ADD --chown=oracle:dba ./checkDBStatus-11c.sh /u01/app/oracle/checkDBStatus.sh
RUN chmod 755 /entrypoint-11c.sh /u01/app/oracle/checkDBStatus.sh

USER oracle

EXPOSE 1521 8080

HEALTHCHECK --interval=30s --timeout=10s --start-period=10m --retries=5 \
  CMD /u01/app/oracle/checkDBStatus.sh

ENTRYPOINT ["/entrypoint-11c.sh"]