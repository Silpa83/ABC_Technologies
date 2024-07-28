FROM docker.io/library/ubuntu:20.04
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install openjdk-17 get
RUN wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.91/bin/apache-tomcat-9.0.91.tar.gz -O /tmp/apache-tomcat-9.0.91.tar.gz && \
    mkdir /usr/local/tomcat && \
    tar -xvf /tmp/apache-tomcat-9.0.91.tar.gz -C /usr/local/tomcat --strip-components=1 && \
    rm /tmp/apache-tomcat-9.0.91.tar.gz
# Copy WAR files to Tomcat's webapps directory
ADD **/*.war /usr/local/tomcat/webapps/

# Expose the port Tomcat is running on
EXPOSE 8080

# Run Tomcat
CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]

