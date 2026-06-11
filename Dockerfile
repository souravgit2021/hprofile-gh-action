# Stage 1: Build the artifact using a Maven image with Java 11
FROM maven:3.8-eclipse-temurin-11 AS BUILD_IMAGE
RUN apt update && apt install git -y
# Set a working directory for clean path management
WORKDIR /app
RUN git clone https://github.com/souravgit2021/hprofile-gh-action.git .
RUN mvn clean install

# Stage 2: Deploy to Tomcat
FROM tomcat:9.0-jre11-temurin
LABEL "Project"="Vprofile"
LABEL "Author"="Sourav"

# Clean up default Tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the built WAR file from the build stage
COPY --from=BUILD_IMAGE /app/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]