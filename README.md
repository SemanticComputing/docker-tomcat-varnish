# tomcat-varnish

## Notes

### Tomcat

Environemt variables:
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
```
These are defined at built-time and are not inteded to be changed.

By default the tomcat app resides at `PATH_WEBAPPS`. You could mount it or copy it over in a downstream image. If you need to do a custom entrypoint, you can call `$EXEC_TOMCAT_VARNISH` to launch tomcat+varnish.

### Varnish

For details and configuration of the included varnish cache, see the docker-varnish -repository.

## Pulling

rahti-scripts is a submodule therefore you might want to use

```
git clone --recursive
```
and

```
git pull --recurse-submodules
```


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


## Running on Rahti

### Initialize OpenShift resources

```
./rahti-init.sh
```
Can be done via the web intarface as well. See rahti-params.sh for the template and parameters to use.

### Rebuild the service

```
./rahti-rebuild.sh
```
Can be done via the web interface as well. Navigate to the BuildConfig in question and click "Start Build"

### Remove the OpenShift resources

```
./rahti-scrap.sh
```

### Webhooks

The template also generates WebHook for triggering the build followed by redeploy.
You can see the exact webhook URL with e.g. following commands
```
oc describe bc <ENVIRONMENT>-<APP_NAME> | grep -A 1 "Webhook"
oc describe bc -l "app=<APP_NAME>,environment=<ENVIRONMENT>"
```
or via the OpenShift web console by navigating to the BuildConfig in question.
