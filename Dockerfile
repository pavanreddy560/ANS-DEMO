FROM tomcat:9.0.65
COPY target/spring-boot-thymeleaf-2.0.0.war /usr/local/tomcat/webapps
EXPOSE 8080
CMD ["catalina.sh","run"]


#FROM ubuntu
#RUN apt update
#RUN apt install default-jdk -y
##RUN echo java -version
#RUN mkdir /opt/tomcat
#WORKDIR /opt/tomcat/
#ADD https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.65/bin/apache-tomcat-9.0.65.tar.gz .
#RUN tar -xvzf apache-tomcat-9.0.65.tar.gz
#RUN mv apache-tomcat-9.0.65/* /opt/tomcat
#COPY target/spring-boot-thymeleaf-2.0.0.war opt/tomcat/webapps/
#EXPOSE 8080
#CMD ["/bin/startup.sh","run"]
