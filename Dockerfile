FROM debezium/connect:1.4

LABEL Author="Alef Bruno Delpino de Oliveira"
LABEL Email="alef@delpinos.com"

ENV GROUP_ID="debezium-connect"
ENV KEY_CONVERTER="org.apache.kafka.connect.json.JsonConverter"
ENV VALUE_CONVERTER="org.apache.kafka.connect.json.JsonConverter"
ENV INTERNAL_KEY_CONVERTER="org.apache.kafka.connect.json.JsonConverter"
ENV INTERNAL_VALUE_CONVERTER="org.apache.kafka.connect.json.JsonConverter"
ENV CONFIG_STORAGE_TOPIC="debezium-connect.configs"
ENV OFFSET_STORAGE_TOPIC="debezium-connect.offsets"
ENV STATUS_STORAGE_TOPIC="debezium-connect.status"
ENV CONFIG_STORAGE_REPLICATION_FACTOR=1
ENV OFFSET_STORAGE_REPLICATION_FACTOR=1
ENV STATUS_STORAGE_REPLICATION_FACTOR=1

USER root

COPY src/etc/yum.repos.d /etc/yum.repos.d

RUN rpm --rebuilddb && \
    yum install -y epel-release && \
    yum update -y && \
    yum install -y \
        bzip2-devel \
        curl \
        gcc \
        hostname \
        inotify-tools \
        iotop \
        iproute \
        jo \
        jq \      
        libffi-devel \ 
        openssl-devel \
        python3 \
        telnet \
        vim \
        wget \
        which \
        yum-utils && \
    yum clean all && \
    rm -rf /tmp/yum*    

RUN pip3 install supervisor

COPY src /

WORKDIR /scripts

RUN chmod +x /scripts/*.sh

ENTRYPOINT ["/scripts/entrypoint.sh"]