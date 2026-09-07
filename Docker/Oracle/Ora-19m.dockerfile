FROM registry.jetbrains.team/p/datagrip/containers/oracle:19.3-e-orig
USER root

RUN sed -i -e 's/^totalMemory=.*/totalMemory=4096/' /opt/oracle/dbca.rsp.tmpl


USER oracle

ENV ORACLE_BASE=/opt/oracle \
    ORACLE_CHARACTERSET=AL32UTF8
