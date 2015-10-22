#!/bin/bash
# Kafka and Zookeeper

# rest proxy for kafka
#FROM confluent/platform

FROM java:openjdk-8-jre
FROM ubuntu

ENV SCALA_VERSION="2.10.4"
ENV JAVA_VERSION="7"
ENV CONFLUENT_MAJOR_VERSION="1.0"

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y curl openjdk-${JAVA_VERSION}-jre-headless && \
    curl -SL http://packages.confluent.io/deb/${CONFLUENT_MAJOR_VERSION}/archive.key | apt-key add - && \
    echo "deb [arch=all] http://packages.confluent.io/deb/${CONFLUENT_MAJOR_VERSION} stable main" >> /etc/apt/sources.list && \
   apt-get update && \
   apt-get install -y confluent-platform-${SCALA_VERSION}

ENV DEBIAN_FRONTEND noninteractive
ENV SCALA_VERSION 2.11
ENV KAFKA_VERSION 0.8.2.1
ENV KAFKA_HOME /opt/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION"

# secor ENV variables
ENV BUILD_DEPS git openjdk-7-jdk maven
ENV RUNTIME_DEPS openjdk-7-jre-headless

# Install mosquitto and client
RUN apt-get install -y mosquitto
RUN apt-get install -y mosquitto-clients

# Install secor
RUN apt-get install -y $BUILD_DEPS $RUNTIME_DEPS --no-install-recommends

# Install Kafka, Zookeeper and other needed things
RUN apt-get install -y zookeeper wget supervisor dnsutils && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

RUN wget -q http://apache.mirrors.spacedump.net/kafka/"$KAFKA_VERSION"/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -O /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz && \
    tar xfz /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -C /opt && \
    rm /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz


# kafka directory start-kafka, logs, MQTTtoKAFKA, create-topics, rest-proxy-docker
COPY ./secor/kafka/scripts /usr/bin

# secor setup
COPY ./secor/SECOR_INSTALL_DIR /opt/secor

WORKDIR /opt/secor

# chmod scripts
RUN chmod +x /usr/bin/create-kafka-topics.sh
RUN chmod +x /usr/bin/start-kafka.sh
RUN chmod +x /usr/bin/MQTTtoKAFKA.sh
RUN chmod +x /opt/secor/secor_start.sh

# chmod rest proxy
RUN chmod +x /usr/bin/rest-proxy-docker.sh

# Supervisor config
COPY /secor/kafka/supervisor /etc/supervisor/conf.d/
#ADD kafka/supervisor/kafka.conf /etc/supervisor/conf.d/kafka.conf
#ADD kafka/supervisor/zookeeper.conf /etc/supervisor/conf.d/zookeeper.conf
#ADD kafka/supervisor/mqtt2kafka.conf /etc/supervisor/conf.d/mqtt2kafka.conf
#ADD kafka/supervisor/mqtt.conf /etc/supervisor/conf.d/mqtt.conf
ADD ./secor/SECOR_INSTALL_DIR/supervisor/secor.conf /etc/supervisor/conf.d/secor.conf



# 2181 is zookeeper, 9092 is kafka, 1883 and 8883 for mqtt node in nodered
EXPOSE 2181
EXPOSE 1883
EXPOSE 9092
EXPOSE 8883
# rest-proxy for kafka
EXPOSE 9443

CMD ["supervisord", "-n"] 