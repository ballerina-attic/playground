ARG BALLERINA_VERSION

FROM ballerina/ballerina:$BALLERINA_VERSION

LABEL maintainer "ballerina.io"

WORKDIR /api
COPY api/*.jar /api

COPY plugins/*.jar $BALLERINA_HOME/bre/lib/
RUN cp $BALLERINA_HOME/bre/lib/*.jar $(ballerina home)/bre/lib/

USER root

RUN chown -R ballerina:troupe /api && \
    chmod +x /api/playground_compiler.jar

USER ballerina

EXPOSE 9090

CMD ["java", "-jar", "playground_compiler.jar", "--b7a.log.level=ALL"]