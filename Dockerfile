FROM secoresearch/varnish


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
ENV PATH_ETC_TOMCAT "/etc/tomcat7"
ENV PATH_WEBAPPS "$CATALINA_BASE/webapps"
ENV PATH_WEBAPP_ROOT "$PATH_WEBAPPS/ROOT"
ENV PATH_TOMCAT_WORK "$CATALINA_BASE/work"
ENV PATH_TOMCAT_USR_COMMON_CLASSES "$CATALINA_HOME/common/classes"
ENV PATH_TOMCAT_USR_SERVER_CLASSES "$CATALINA_HOME/server/classes"
ENV PATH_TOMCAT_USR_SHARED_CLASSES "$CATALINA_HOME/shared/classes"
ENV PATH_TOMCAT_VAR_COMMON_CLASSES "$CATALINA_BASE/common/classes"
ENV PATH_TOMCAT_VAR_SERVER_CLASSES "$CATALINA_BASE/server/classes"
ENV PATH_TOMCAT_VAR_SHARED_CLASSES "$CATALINA_BASE/shared/classes"
ENV PATH_TOMCAT_CACHE "/var/cache/tomcat7"
ENV FILE_PID_TOMCAT "/run/tomcat.pid"
ENV PATH_LOG "/log"
ENV FILE_CONF_TOMCAT_LOGGING "$CATALINA_BASE/conf/logging.properties"
ENV FILE_LOG_TOMCAT "$PATH_LOG/tomcat.log"
ENV FILE_ERR_TOMCAT "$PATH_LOG/tomcat.err"
ENV FILE_ERR_VARNISH "$PATH_LOG/varnish.log"
ENV FILE_LOG_VARNISH "$PATH_LOG/varnish.err"
ENV RUN_TOMCAT "/run-tomcat.sh"
ENV EXEC_TOMCAT "exec $RUN_TOMCAT"
ENV RUN_TOMCAT_VARNISH "/run-tomcat-varnish.sh"
ENV EXEC_TOMCAT_VARNISH "exec $RUN_TOMCAT_VARNISH"

# PERMISSIONS
RUN D="$CATALINA_HOME"                  && mkdir -p "$D" && chgrp -R root "$D" && chmod g=u -R "$D" && \
    D="$CATALINA_BASE"                  && mkdir -p "$D" && chgrp -R root "$D" && chmod g=u -R "$D" && \
    D="$PATH_ETC_TOMCAT"                && mkdir -p "$D" && chgrp -R root "$D" && chmod g=u -R "$D" && \
    D="$PATH_LOG"                       && mkdir -p "$D" && chgrp -R root "$D" && chmod g=u -R "$D" && \
    D="$PATH_TOMCAT_WORK"               && mkdir -p "$D" && chgrp -R root "$D" && chmod g=u -R "$D" && \
    D="$PATH_WEBAPPS"                   && mkdir -p "$D" && chgrp -R root "$D" && chmod g=u -R "$D" && \
    D="$PATH_WEBAPP_ROOT"               && mkdir -p "$D" && chgrp -R root "$D" && chmod g=u -R "$D" && \
    D="$PATH_TOMCAT_VAR_COMMON_CLASSES" && mkdir -p "$D" && chgrp -R root "$D" && chmod g=u -R "$D" && \
    D="$PATH_TOMCAT_VAR_SERVER_CLASSES" && mkdir -p "$D" && chgrp -R root "$D" && chmod g=u -R "$D" && \
    D="$PATH_TOMCAT_VAR_SHARED_CLASSES" && mkdir -p "$D" && chgrp -R root "$D" && chmod g=u -R "$D" && \
    D="$PATH_TOMCAT_USR_COMMON_CLASSES" && mkdir -p "$D" && chgrp -R root "$D" && chmod g=u -R "$D" && \
    D="$PATH_TOMCAT_USR_SERVER_CLASSES" && mkdir -p "$D" && chgrp -R root "$D" && chmod g=u -R "$D" && \
    D="$PATH_TOMCAT_USR_SHARED_CLASSES" && mkdir -p "$D" && chgrp -R root "$D" && chmod g=u -R "$D" && \
    D="$PATH_TOMCAT_CACHE"              && mkdir -p "$D" && chgrp -R root "$D" && chmod g=u -R "$D" && \
    F="$FILE_LOG_TOMCAT"        && D="$(dirname "$F")" && mkdir -p "$D" && chmod g=u "$D" && touch "$F"  && chmod g=u "$F" && \
    F="$FILE_ERR_TOMCAT"        && D="$(dirname "$F")" && mkdir -p "$D" && chmod g=u "$D" && touch "$F"  && chmod g=u "$F" && \
    F="$FILE_LOG_VARNISH"       && D="$(dirname "$F")" && mkdir -p "$D" && chmod g=u "$D" && touch "$F"  && chmod g=u "$F" && \
    F="$FILE_ERR_VARNISH"       && D="$(dirname "$F")" && mkdir -p "$D" && chmod g=u "$D" && touch "$F"  && chmod g=u "$F" && \
    F="$FILE_PID_TOMCAT"        && D="$(dirname "$F")" && mkdir -p "$D" && chmod g=u "$D" && touch "$F"  && chmod g=u "$F"

# Link tomcat log location to PATH_LOG
RUN rm "$CATALINA_BASE/logs" && ln -s "$PATH_LOG" "$CATALINA_BASE/logs"

# ENTRY
COPY run-tomcat "$RUN_TOMCAT"
COPY run "$RUN_TOMCAT_VARNISH"
ENTRYPOINT [ "/run-tomcat-varnish.sh" ]
EXPOSE 80
