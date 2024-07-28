FROM ubuntu:20.04

# Update and upgrade the system
RUN apt-get -y update && apt-get -y upgrade
# Set the environment variable to non-interactive to avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Use the official OpenJDK 17 image as the base image
FROM openjdk:17-jdk

# Update the package list and install wget and OpenJDK 17
RUN apt-get update && \
    apt-get install -y wget openjdk-17-jdk && \
    rm -rf /var/lib/apt/lists/*

# Create the Tomcat directory
RUN mkdir /usr/local/tomcat

# Download and extract Tomcat 9.0.91
RUN wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.91/bin/apache-tomcat-9.0.91.tar.gz -O /tmp/apache-tomcat-9.0.91.tar.gz && \
    tar -xvf /tmp/apache-tomcat-9.0.91.tar.gz -C /usr/local/tomcat --strip-components=1 && \
    rm /tmp/apache-tomcat-9.0.91.tar.gz

# Copy WAR files to Tomcat's webapps directory
ADD **/*.war /usr/local/tomcat/webapps/

# Expose the port Tomcat is running on
EXPOSE 8080

# Run Tomcat
CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]

