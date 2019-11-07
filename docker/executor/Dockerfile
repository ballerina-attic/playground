FROM anapsix/alpine-java:8_jdk

LABEL maintainer "ballerina-dev@googlegroups.com"

RUN mkdir -p /api && \
    addgroup troupe && \
    adduser -g '' -s /bin/bash -D -G troupe ballerina

COPY api/*.jar /api

RUN chown -R ballerina:troupe /api && \
    chmod +x /api/playground_executor.jar

USER ballerina

EXPOSE 9090

CMD ["java", "-jar", "/api/playground_executor.jar", "--b7a.log.level=ALL"]