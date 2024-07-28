FROM ubuntu:20.04

RUN apt-get update && apt-get install -y wget openjdk-11-jdk

# Download Apache Tomcat
RUN wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.73/bin/apache-tomcat-9.0.73.tar.gz -O /tmp/apache-tomcat-9.0.73.tar.gz

# Extract and setup Tomcat
RUN mkdir /opt/tomcat && \
    tar xzvf /tmp/apache-tomcat-9.0.73.tar.gz -C /opt/tomcat --strip-components=1

# Add the WAR file to the Tomcat webapps directory
COPY target/*.war /opt/tomcat/webapps/

EXPOSE 8080

CMD ["/opt/tomcat/bin/catalina.sh", "run"]

