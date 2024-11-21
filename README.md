# tomcat-varnish

## Notes

### Tomcat

Environment variables:
```
CATALINA_HOME # /opt/apache-tomcat-7.0.109
CATALINA_BASE # /opt/apache-tomcat-7.0.109
PATH_WEBAPPS # $CATALINA_BASE/webapps
PATH_LOG # /log
FILE_LOG_TOMCAT # $PATH_LOG/tomcat.out
FILE_ERR_TOMCAT # $PATH_LOG/tomcat.err
FILE_PID_TOMCAT # /run/tomcat.pid
FILE_CONF_TOMCAT_LOGGING # $CATALINA_BASE/conf/logging.properties
RUN_TOMCAT_VARNISH # /run-tomcat-varnish.sh 
EXEC_TOMCAT_VARNISH # exec $RUN_TOMCAT_VARNISH
JAVA_XMS # Control JVMs heap memory, java -Xms ...
JAVA_XMX # Control JVMs heap memory, java -Xmx ...
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