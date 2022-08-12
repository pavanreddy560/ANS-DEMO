FROM tomcat:9.0.65
COPY target/spring-boot-thymeleaf-2.0.0.war /usr/local/tomcat/webapps
EXPOSE 8080
CMD ["catalina.sh","run"]
