FROM registry.jetbrains.team/p/datagrip/containers/oracle:23.26.2.0-free-orig
USER root

RUN sed -i -e 's/^totalMemory=.*/totalMemory=4096/' /opt/oracle/product/26ai/dbhomeFree/assistants/dbca/dbca.rsp

ENV ORACLE_BASE=/opt/oracle \
    ORACLE_CHARACTERSET=AL32UTF8

USER oracle