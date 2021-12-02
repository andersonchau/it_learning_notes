# Spring Boot + MySQL + Docker Compose


How To Build Docker Images : 
prelim :
a. create c:\docker_volume\mysql_db to store database file
b. if you want to run mysql init script : you have to empty c:\docker_volume\mysql_db folder



1. ./mvnw package ( or ./gradlew bootjar )
2. copy jar to ./sb_app_docker/target/ (Dockerfile cannot access parent folder)\
3. docker-compose up
4. test Spring Boot MYSQL access with http://localhost:10000/API-PATH