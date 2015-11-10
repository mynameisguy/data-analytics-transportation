#!/bin/bash

sudo java -ea -Dsecor_group=secor_backup -Dlog4j.configuration=log4j.prod.properties -Dconfig=secor.prod.partition.properties -cp secor-0.1-SNAPSHOT.jar:lib/* com.pinterest.secor.main.ConsumerMain > logs/secor.log 2>&1

