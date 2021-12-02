FROM adoptopenjdk/openjdk8-openj9:ubi
RUN mkdir /opt/app
COPY ./target/demo-0.0.1-SNAPSHOT.jar /opt/app
COPY ./wait-for-it.sh /opt/app/wait-for-it.sh
RUN chmod +x /opt/app/wait-for-it.sh
WORKDIR /opt/app 
EXPOSE 8080
CMD ["./wait-for-it.sh" , "mysqldb:3306" , "--strict" , "--timeout=300" , "--" , "java" ,"-jar", "/opt/app/demo-0.0.1-SNAPSHOT.jar"]