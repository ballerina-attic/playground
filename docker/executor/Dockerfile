FROM openjdk:8u282-jre

LABEL maintainer "ballerina-dev@googlegroups.com"

WORKDIR /api
COPY api/*.jar /api

WORKDIR /ballerina

ADD https://dist.ballerina.io/downloads/swan-lake-alpha1/ballerina-swan-lake-alpha1.zip /ballerina/dist/

RUN unzip /ballerina/dist/ballerina-swan-lake-alpha1.zip -d /ballerina/ \
    && mv /ballerina/ballerina* /ballerina/runtime

ENV BALLERINA_HOME /ballerina/runtime
ENV PATH $BALLERINA_HOME/bin:$PATH
    
ADD https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.10%2B9/OpenJDK11U-jre_x64_linux_hotspot_11.0.10_9.tar.gz /ballerina/dist/

RUN tar -xf /ballerina/dist/OpenJDK11U-jre_x64_linux_hotspot_11.0.10_9.tar.gz -C /ballerina/runtime/dependencies \
    && rm -rf /ballerina/dist

ENV JAVA_HOME /ballerina/runtime/dependencies/jdk-11.0.10+9-jre

EXPOSE 9090

CMD ["java", "-jar", "/api/playground_executor.jar", "--b7a.log.level=ALL"]