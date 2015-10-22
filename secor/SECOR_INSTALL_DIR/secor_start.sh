#!/bin/bash

#create kafka topics
#sleep 5
#/usr/bin/create-topics.sh

#host change in container
export TEST_HOST=`hostname`
export TEST_IP=`ifconfig | grep "inet addr" | grep -v "\<127." | awk '{print $2}' | awk -F ":" '{print $2}'`
echo -e "$TEST_IP    $TEST_HOST" >>/etc/hosts 

sudo java -ea -Dsecor_group=secor_backup -Dlog4j.configuration=log4j.prod.properties -Dconfig=secor.prod.partition.properties -cp secor-0.1-SNAPSHOT.jar:lib/* com.pinterest.secor.main.ConsumerMain > logs/secor.log 2>&1

cat logs/secor.log
