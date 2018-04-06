FROM varnish:latest


# INSTALL PROGRAMS

RUN echo "deb  http://deb.debian.org/debian jessie main" >> /etc/apt/sources.list
RUN echo "deb-src  http://deb.debian.org/debian jessie main" >> /etc/apt/sources.list

RUN apt-get update

RUN apt-get install -y openjdk-8-jdk
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

RUN apt-get install -y tomcat8
RUN apt-get install -y maven
RUN apt-get install -y git
RUN apt-get install -y jsvc

# vim just for dev debugging, remove when more stable
RUN apt-get install -y vim


# ENVIRONMENT VARIBLES
ENV CATALINA_HOME "/usr/share/tomcat8"
ENV CATALINA_BASE "/var/lib/tomcat8"
ENV PATH_LOG_TOMCAT "/var/log/tomcat8"
ENV FILE_LOG_TOMCAT_OUT "$PATH_LOG_TOMCAT/catalina.out"
ENV FILE_LOG_TOMCAT_ERROR "$PATH_LOG_TOMCAT/catalina.err"
ENV FILE_PID_TOMCAT "/run/tomcat.pid"
ENV FILE_CONF_TOMCAT_LOGGING "$CATALINA_BASE/conf/logging.properties"
ENV RUN_TOMCAT_VARNISH "/run-tomcat-varnish.sh"
ENV EXEC_TOMCAT_VARNISH "exec $RUN_TOMCAT_VARNISH"
ENV test "\test test"


# PERMISSIONS
# R access directories
ENV PATHS "'$CATALINA_HOME' '$CATALINA_BASE'"
RUN eval "mkdir -p $PATHS; chgrp -L -R root $PATHS"

# RW access directories
ENV PATHS "'$PATH_LOG_TOMCAT'"
RUN eval "mkdir -p $PATHS; chgrp root $PATHS; chmod -R g=u $PATHS"

# RW access files
ENV PATHS " \
    '$FILE_LOG_VARNISH' \
    '$FILE_LOG_TOMCAT_OUT' \
    '$FILE_LOG_TOMCAT_ERROR' \
    '$FILE_PID_TOMCAT' "
RUN eval "touch $PATHS; chgrp root $PATHS; chmod g=u $PATHS"

ENV PATHS ""


# ENTRY
COPY run "$RUN_TOMCAT_VARNISH"
ENTRYPOINT [ "/run-tomcat-varnish.sh" ]
EXPOSE 80
