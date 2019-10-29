ARG BALLERINA_VERSION

FROM ballerina/ballerina:$BALLERINA_VERSION

LABEL maintainer "ballerina.io"

COPY plugins/*.jar $BALLERINA_HOME/bre/lib

WORKDIR /api
COPY api/*.jar /api

USER root

RUN chown -R ballerina:troupe /api && \
    chmod +x /api/playground_compiler.jar

USER ballerina

EXPOSE 9090

CMD ["java", "-jar", "playground_compiler.jar"]