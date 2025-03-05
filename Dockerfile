FROM tomcat:9.0
COPY target/basic-webapp.war /opt/tomcat9/webapps/basic-webapp.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
