FROM secoresearch/varnish


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
ENV PATH_WEBAPPS "$CATALINA_BASE/webapps"
ENV PATH_TOMCAT_WORK "/var/lib/tomcat8/work"
ENV FILE_PID_TOMCAT "/run/tomcat.pid"
ENV PATH_LOG "/log"
ENV FILE_CONF_TOMCAT_LOGGING "$CATALINA_BASE/conf/logging.properties"
ENV FILE_LOG_TOMCAT "$PATH_LOG/tomcat.log"
ENV FILE_LOG_TOMCAT_ERR "$PATH_LOG/tomcat-err.log"
ENV FILE_LOG_VARNISH "$PATH_LOG/varnish.log"
ENV FILE_LOG_VARNISH_ERR "$PATH_LOG/varnish-err.log"
ENV RUN_TOMCAT "/run-tomcat.sh"
ENV EXEC_TOMCAT "exec $RUN_TOMCAT"
ENV RUN_TOMCAT_VARNISH "/run-tomcat-varnish.sh"
ENV EXEC_TOMCAT_VARNISH "exec $RUN_TOMCAT_VARNISH"


# PERMISSIONS
# R access directories
ENV PATHS "'$CATALINA_HOME' '$CATALINA_BASE'"
RUN eval "mkdir -p $PATHS; chgrp -L -R root $PATHS"
# RW access directories
ENV PATHS "'$PATH_LOG' '$PATH_TOMCAT_WORK'"
RUN eval "mkdir -p $PATHS; chgrp root -R $PATHS; chmod -R g=u $PATHS"
# RW access files
ENV PATHS " \
    '$FILE_PID_TOMCAT' "
RUN eval "touch $PATHS; chgrp root $PATHS; chmod g=u $PATHS"

ENV PATHS ""

# ENTRY
COPY run-tomcat "$RUN_TOMCAT"
COPY run "$RUN_TOMCAT_VARNISH"
ENTRYPOINT [ "/run-tomcat-varnish.sh" ]
EXPOSE 80
