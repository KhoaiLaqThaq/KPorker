FROM openjdk:8-jdk-alpine
VOLUME /tmp
WORKDIR /opt
ARG JAR_FILE=target/noti-web-1.0.0.war
ADD ${JAR_FILE} app.war
EXPOSE 8080
#RUN bash -c 'touch /app.war'
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","app.war"]
