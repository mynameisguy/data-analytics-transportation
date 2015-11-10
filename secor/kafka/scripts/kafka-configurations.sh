#!/bin/bash

sleep 10

#host change in container
export TEST_HOST=`hostname`
export TEST_IP=`ifconfig | grep "inet addr" | grep -v "\<127." | awk '{print $2}' | awk -F ":" '{print $2}'`
echo -e "$TEST_IP    $TEST_HOST" >>/etc/hosts


#create kafka
KAFKA_HOST=localhost

SECORTOPIC=TrafficFlowMadridPM
THRESHOLDTOPIC=newThresholds

/opt/kafka_2.11-0.8.2.1/bin/kafka-topics.sh --create --zookeeper ${KAFKA_HOST}:2181 --replication-factor 1 --partition 1 --topic $SECORTOPIC

/opt/kafka_2.11-0.8.2.1/bin/kafka-topics.sh --create --zookeeper ${KAFKA_HOST}:2181 --replication-factor 1 --partition 1 --topic $THRESHOLDTOPIC
