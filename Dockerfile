FROM varnish:latest

RUN echo "deb  http://deb.debian.org/debian jessie main" >> /etc/apt/sources.list
RUN echo "deb-src  http://deb.debian.org/debian jessie main" >> /etc/apt/sources.list

RUN apt-get update

RUN apt-get install -y openjdk-8-jdk
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

RUN apt-get install -y tomcat8
RUN apt-get install -y maven
RUN apt-get install -y git

# vim just for dev debugging, remove when more stable
RUN apt-get install -y vim


EXPOSE 80