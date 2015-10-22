#!/bin/bash

export TEST_HOST=`hostname`
export TEST_IP=`ifconfig | grep "inet addr" | grep -v "\<127." | awk '{print $2}' | awk -F ":" '{print $2}'`
echo -e "$TEST_IP    $TEST_HOST" >>/etc/hosts

set -x

MQTT_HOST=localhost
KAFKA_HOST=localhost

sleep 10
mosquitto_sub -t cosmos/TrafficFlowMadrid/thePMs0 -h ${MQTT_HOST} | /opt/kafka_2.11-0.8.2.1/bin/kafka-console-producer.sh --broker-list ${KAFKA_HOST}:9092 --topic TrafficFlowMadridPM > /usr/bin/logs/bridge.log 2>&1
#function mosquitto {
#        mosquitto_sub -t cosmos/TrafficFlowMadrid/thePMs0 -h ${MQTT_HOST} | /opt/kafka_2.11-0.8.2.1/bin/kafka-console-producer.sh --broker-list ${KAFKA_HOST}:9092 --topic test3 > /usr/bin/logs/bridge.log 2>&1 &
#}

#until mosquitto; do
#        echo "mosquitto bridge is dead... restarting" 2>&1
#        sleep 1
#done
