ARG varnish_version=latest
FROM secoresearch/varnish:${varnish_version}


# INSTALL PROGRAMS

RUN apt-get update && \
    apt install -y apt-transport-https gpg wget

# Java 8
RUN wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | tee /etc/apt/trusted.gpg.d/adoptium.gpg > /dev/null && \
    echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list

RUN apt-get update && \
    apt-get install -y temurin-8-jdk \
    maven \
    git \
    jsvc \
    vim


WORKDIR /opt
RUN wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.108/bin/apache-tomcat-9.0.108.tar.gz
RUN tar xzvf apache-tomcat-9.0.108.tar.gz
RUN rm apache-tomcat-9.0.108.tar.gz
WORKDIR /

# ENVIRONMENT VARIBLES
ENV JAVA_HOME=/usr/lib/jvm/temurin-8-jdk-amd64
ENV CATALINA_HOME "/opt/apache-tomcat-9.0.108"
ENV CATALINA_BASE "$CATALINA_HOME"
ENV PATH_WEBAPPS "$CATALINA_BASE/webapps"
ENV PATH_WEBAPP_ROOT "$PATH_WEBAPPS/ROOT"
ENV PATH_TOMCAT_WORK "$CATALINA_BASE/work"
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
    D="$PATH_LOG"                       && mkdir -p "$D" && chgrp -R root "$D" && chmod g=u -R "$D" && \
    D="$PATH_TOMCAT_WORK"               && mkdir -p "$D" && chgrp -R root "$D" && chmod g=u -R "$D" && \
    D="$PATH_WEBAPPS"                   && mkdir -p "$D" && chgrp -R root "$D" && chmod g=u -R "$D" && \
    D="$PATH_WEBAPP_ROOT"               && mkdir -p "$D" && chgrp -R root "$D" && chmod g=u -R "$D" && \
    F="$FILE_LOG_TOMCAT"        && D="$(dirname "$F")" && mkdir -p "$D" && chmod g=u "$D" && touch "$F"  && chmod g=u "$F" && \
    F="$FILE_ERR_TOMCAT"        && D="$(dirname "$F")" && mkdir -p "$D" && chmod g=u "$D" && touch "$F"  && chmod g=u "$F" && \
    F="$FILE_LOG_VARNISH"       && D="$(dirname "$F")" && mkdir -p "$D" && chmod g=u "$D" && touch "$F"  && chmod g=u "$F" && \
    F="$FILE_ERR_VARNISH"       && D="$(dirname "$F")" && mkdir -p "$D" && chmod g=u "$D" && touch "$F"  && chmod g=u "$F" && \
    F="$FILE_PID_TOMCAT"        && D="$(dirname "$F")" && mkdir -p "$D" && chmod g=u "$D" && touch "$F"  && chmod g=u "$F"

# Link tomcat log location to PATH_LOG
RUN rmdir "$CATALINA_BASE/logs" && ln -s "$PATH_LOG" "$CATALINA_BASE/logs"

# ENTRY
COPY run-tomcat "$RUN_TOMCAT"
COPY run "$RUN_TOMCAT_VARNISH"
ENTRYPOINT [ "/run-tomcat-varnish.sh" ]
