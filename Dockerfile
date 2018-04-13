FROM varnish:latest


# INSTALL PROGRAMS

RUN echo "deb  http://deb.debian.org/debian jessie main" >> /etc/apt/sources.list
RUN echo "deb-src  http://deb.debian.org/debian jessie main" >> /etc/apt/sources.list

RUN apt-get update


COPY jdk-6u45-linux-x64.bin /usr/lib/jvm/
WORKDIR /usr/lib/jvm
RUN chmod +x /usr/lib/jvm/jdk-6u45-linux-x64.bin
RUN /usr/lib/jvm/jdk-6u45-linux-x64.bin
RUN rm /usr/lib/jvm/jdk-6u45-linux-x64.bin
#RUN mv /jdk1.6.0_45 /usr/lib/jvm/

ENV JAVA_HOME "/usr/lib/jvm/jdk1.6.0_45/"

RUN apt-get install -y tomcat7
#RUN apt-get install -y maven
RUN apt-get install -y git
RUN apt-get install -y jsvc

# vim just for dev debugging, remove when more stable
RUN apt-get install -y vim

# ENVIRONMENT VARIBLES
ENV CATALINA_HOME "/usr/share/tomcat7"
ENV CATALINA_BASE "/var/lib/tomcat7"
ENV PATH_WEBAPPS "$CATALINA_BASE/webapps"
ENV PATH_LOG_TOMCAT "/var/log/tomcat7"
ENV FILE_LOG_TOMCAT_OUT "$PATH_LOG_TOMCAT/catalina.out"
ENV FILE_LOG_TOMCAT_ERROR "$PATH_LOG_TOMCAT/catalina.err"
ENV FILE_PID_TOMCAT "/run/tomcat.pid"
ENV FILE_CONF_TOMCAT_LOGGING "$CATALINA_BASE/conf/logging.properties"
ENV RUN_TOMCAT_VARNISH "/run-tomcat-varnish.sh"
ENV EXEC_TOMCAT_VARNISH "exec $RUN_TOMCAT_VARNISH"


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