FROM ubuntu:20.04

# Install necessary packages
RUN apt-get update && apt-get install -y wget openjdk-11-jdk

# Download and install Apache Tomcat
RUN wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.73/bin/apache-tomcat-9.0.73.tar.gz -O /tmp/apache-tomcat-9.0.73.tar.gz \
    && mkdir /opt/tomcat \
    && tar xzvf /tmp/apache-tomcat-9.0.73.tar.gz -C /opt/tomcat --strip-components=1

# Add the WAR file to the Tomcat webapps directory
COPY target/*.war /opt/tomcat/webapps/

# Expose the port
EXPOSE 8080

# Start Tomcat
CMD ["/opt/tomcat/bin/catalina.sh", "run"]

