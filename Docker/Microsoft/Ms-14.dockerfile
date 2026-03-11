FROM registry.jetbrains.team/p/datagrip/containers/mssql-server-linux:2017orig

LABEL author=DataGrip
USER root

RUN apt-get update && apt-get install -y \
    curl \
    iproute2 \
    debconf-utils \
    gnupg2 \
    unixodbc-dev \
    jq

#RUN useradd -M -s /bin/bash -u 10001 -g 0 mssql
RUN useradd -M -s /bin/bash -u 1000 -g 0 mssql
RUN mkdir /scripts
RUN chown -R 1000:1000 /scripts
RUN chmod -R 771 /scripts
RUN chown -R 1000:1000 /opt/mssql/bin/

ADD ./entrypoint-14.sh /
RUN chmod +x /entrypoint-14.sh

RUN mkdir -p /.system && \
    chown 1000:1000 /.system && \
    chmod 775 /.system

RUN mkdir -p /var/opt/mssql && \
    chown -R mssql:1000 /var/opt/mssql && \
    chmod -R g+rwx /var/opt/mssql

USER mssql

EXPOSE 1433

WORKDIR /scripts

ENTRYPOINT ["/entrypoint-14.sh"]
