FROM openjdk:8u282-jre

LABEL maintainer "ballerina-dev@googlegroups.com"

RUN echo 'set +o history' >> /etc/bash.bashrc \
    && apt remove iputils-ping wget curl -y \
    && addgroup troupe \
    && adduser --system --no-create-home  --shell /bin/rbash --gecos 'ballerina' --ingroup troupe --disabled-password --disabled-login ballerina \
    && chmod -R o-rw /tmp /var/tmp /run/lock \ 
    && rm /bin/cat /usr/bin/base64 /usr/bin/base32 /usr/bin/find /bin/echo

WORKDIR /api
COPY api/*.jar /api

WORKDIR /ballerina

ADD https://dist.ballerina.io/downloads/swan-lake-beta3/ballerina-swan-lake-beta3.zip /ballerina/dist/

RUN unzip /ballerina/dist/ballerina-swan-lake-beta3.zip -d /ballerina/ \
    && mv /ballerina/ballerina* /ballerina/runtime

ENV BALLERINA_HOME /ballerina/runtime
ENV PATH $BALLERINA_HOME/bin:$PATH
    
ADD https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.10%2B9/OpenJDK11U-jre_x64_linux_hotspot_11.0.10_9.tar.gz /ballerina/dist/

RUN tar -xf /ballerina/dist/OpenJDK11U-jre_x64_linux_hotspot_11.0.10_9.tar.gz -C /ballerina/runtime/dependencies \
    && rm -rf /ballerina/dist

ENV JAVA_HOME /ballerina/runtime/dependencies/jdk-11.0.10+9-jre

RUN ln -s $(which /ballerina/runtime/dependencies/jdk-11.0.10+9-jre/bin/java) /usr/bin/java11

USER ballerina

EXPOSE 9090

CMD ["java", "-jar", "/api/playground_executor.jar", "--b7a.log.level=ALL"]
