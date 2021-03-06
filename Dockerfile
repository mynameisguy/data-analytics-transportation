FROM ubuntu:15.10

ENV SCALA_VERSION="2.10.4"
ENV JAVA_VERSION="7"

#install sudo
RUN apt-get update && \
	apt-get -y --force-yes install \
	sudo

#install vim
RUN apt-get -y --force-yes install \
	vim

# secor ENV variables
ENV BUILD_DEPS git openjdk-7-jdk maven
ENV RUNTIME_DEPS openjdk-7-jre-headless

RUN apt-get install -y $BUILD_DEPS $RUNTIME_DEPS --no-install-recommends

#supervisor
RUN apt-get install -y openssh-server apache2 supervisor

# secor setup
COPY ./secor/DataServices/SECOR_INSTALL_DIR /opt/secor
WORKDIR /opt/secor
RUN chmod +x /opt/secor/secor_start.sh
RUN chmod +x /opt/secor/scripts/run_kafka_class.sh

# Supervisor config
ADD secor/DataServices/SECOR_INSTALL_DIR/supervisor/secor.conf /etc/supervisor/conf.d/secor.conf

# 2181 is for zookeeper, 9092 is for kafka
EXPOSE 2181

CMD ["supervisord", "-n"]

