# tomcat-varnish

## Notes

### Tomcat

Environment variables:
```
CATALINA_HOME # /usr/share/tomcat8
CATALINA_BASE # /var/lib/tomcat8
PATH_WEBAPPS # $CATALINA_BASE/webapps
PATH_LOG_TOMCAT # /var/log/tomcat8
FILE_LOG_TOMCAT_OUT # $PATH_LOG_TOMCAT/catalina.out
FILE_LOG_TOMCAT_ERROR # $PATH_LOG_TOMCAT/catalina.err
FILE_PID_TOMCAT # /run/tomcat.pid
FILE_CONF_TOMCAT_LOGGING # $CATALINA_BASE/conf/logging.properties
RUN_TOMCAT_VARNISH # /run-tomcat-varnish.sh 
EXEC_TOMCAT_VARNISH # exec $RUN_TOMCAT_VARNISH
JAVA_XMS # Control JVMs heap memory, java -Xms ...
JAVA_XMX # Control JVMs heap memory, java -Xmx ...
JAVA_OPTS # Set Java system properties
```
These are defined at built-time and are not inteded to be changed.

By default the tomcat app resides at `PATH_WEBAPPS`. You could mount it or copy it over in a downstream image. If you need to do a custom entrypoint, you can call `$EXEC_TOMCAT_VARNISH` to launch tomcat+varnish.

### Varnish

For details and configuration of the included varnish cache, see the docker-varnish -repository.


## Building

```
./docker-build.sh [-c]
```
* -c
    * no cache


## Running in docker

```
./docker-run.sh
```
The service is available at localhost:8080 by default.


## Debugging in docker

```
docker exec -it <container-name> bash`
```

Opens bash inside the running container.
