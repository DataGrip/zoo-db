FROM registry.jetbrains.team/p/datagrip/containers/oracle:19.3-e-orig
USER root

RUN usermod -u 1000 oracle
RUN chown -R oracle:1000 /opt/oracle
RUN chmod -R 771 /opt/oracle/scripts/setup

USER oracle

WORKDIR /opt/oracle/scripts/setup