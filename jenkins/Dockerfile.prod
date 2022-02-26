FROM openjdk:8-jre-alpine
ENV TOMCAT_MAJOR=7 \
    TOMCAT_VERSION=7.0.69 \
    TOMCAT_HOME=/opt/tomcat \
    CATALINA_HOME=/opt/tomcat \
    CATALINA_OUT=/dev/null

RUN  wget -P /tmp/ http://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    gunzip /tmp/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    tar -C /opt -xf /tmp/apache-tomcat-${TOMCAT_VERSION}.tar && \
    ln -s /opt/apache-tomcat-${TOMCAT_VERSION} ${TOMCAT_HOME} && \
    rm -rf ${TOMCAT_HOME}/webapps/* && \
    rm -rf /tmp/* /var/cache/apk/*

COPY ./hello.war ${TOMCAT_HOME}/webapps/
EXPOSE 8080
CMD ["/opt/tomcat/bin/catalina.sh", "run"]
