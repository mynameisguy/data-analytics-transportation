#!/bin/bash

export PATH=/opt/ibm/java-x86_64-71/jre/bin/:$PATH

echo "starting zookeeper"
scripts/run_kafka_class.sh \
            org.apache.zookeeper.server.quorum.QuorumPeerMain zookeeper.test.properties > \
            logs/zookeeper.log 2>&1 &

sudo java -ea -Dsecor_group=secor_backup -Dlog4j.configuration=log4j.prod.properties -Dlog4j.debug=true -Dconfig=secor.prod.partition.properties -Djava.security.auth.login.config=jaas.conf -cp secor-0.1-SNAPSHOT.jar:lib/* com.pinterest.secor.main.ConsumerMain > logs/secor.log 2>&1
