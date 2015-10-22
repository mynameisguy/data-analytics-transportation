#!/bin/sh

sleep 10

KAFKA_HOST=localhost

MQTTTOPIC=TrafficFlowMadridPM
TOPIC1=pm10001
TOPIC3=pm10344

/opt/kafka_2.11-0.8.2.1/bin/kafka-topics.sh --create --zookeeper ${KAFKA_HOST}:2181 --replication-factor 1 --partition 1 --topic $MQTTTOPIC

/opt/kafka_2.11-0.8.2.1/bin/kafka-topics.sh --create --zookeeper ${KAFKA_HOST}:2181 --replication-factor 1 --partition 1 --topic $TOPIC1

/opt/kafka_2.11-0.8.2.1/bin/kafka-topics.sh --create --zookeeper ${KAFKA_HOST}:2181 --replication-factor 1 --partition 1 --topic $TOPIC3
