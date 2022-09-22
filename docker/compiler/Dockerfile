FROM openjdk:8u282-jre

LABEL maintainer "ballerina-dev@googlegroups.com"

WORKDIR /api
COPY api/*.jar /api

WORKDIR /ballerina

ADD https://dist.ballerina.io/downloads/2201.2.0/ballerina-2201.2.0-swan-lake.zip /ballerina/dist/

RUN unzip /ballerina/dist/ballerina-2201.2.0-swan-lake.zip -d /ballerina/ \
    && mv /ballerina/ballerina* /ballerina/runtime

ADD choreo-compiler-security-plugin-0.3.1.jar /ballerina/runtime/bre/libs

ENV BALLERINA_HOME /ballerina/runtime
ENV PATH $BALLERINA_HOME/bin:$PATH
    
ADD https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.10%2B9/OpenJDK11U-jre_x64_linux_hotspot_11.0.10_9.tar.gz /ballerina/dist/

RUN tar -xf /ballerina/dist/OpenJDK11U-jre_x64_linux_hotspot_11.0.10_9.tar.gz -C /ballerina/runtime/dependencies \
    && rm -rf /ballerina/dist

ENV JAVA_HOME /ballerina/runtime/dependencies/jdk-11.0.10+9-jre

RUN ln -s $(which /ballerina/runtime/dependencies/jdk-11.0.10+9-jre/bin/java) /usr/bin/java11

EXPOSE 9090

CMD ["java", "-jar", "/api/playground_compiler.jar", "--b7a.log.level=ALL"]
