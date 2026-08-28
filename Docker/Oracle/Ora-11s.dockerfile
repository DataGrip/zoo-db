FROM registry.jetbrains.team/p/datagrip/containers/oracle:11.2.0.2-xe-orig
USER root

RUN usermod -u 1000 oracle
RUN chown -R oracle:oracle /u01/app/oracle
RUN chmod -R 771 /u01/app/oracle/scripts/setup

USER oracle

WORKDIR /u01/app/oracle/scripts/setup
