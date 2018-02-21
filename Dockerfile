FROM varnish:latest

RUN echo "deb  http://deb.debian.org/debian jessie main" >> /etc/apt/sources.list
RUN echo "deb-src  http://deb.debian.org/debian jessie main" >> /etc/apt/sources.list

RUN apt-get update

RUN apt-get install -y tomcat8
RUN apt-get install -y maven
RUN apt-get install -y git
RUN apt-get install -y openjdk-8-jdk

# vim just for dev debugging, remove when more stable
RUN apt-get install -y vim

RUN export JAVA_HOME=/usr/lib/jvm/java-8-openjdk

EXPOSE 80