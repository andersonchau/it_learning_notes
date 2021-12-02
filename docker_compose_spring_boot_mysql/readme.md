# Spring Boot + MySQL + Docker Compose


How To Build Docker Images : 
prelim :
1. create c:\docker_volume\mysql_db to store database file
2. if you want to run mysql init script : you have to empty c:\docker_volume\mysql_db folder


build and start deployment :
1. ./mvnw package ( or ./gradlew bootjar )
2. copy jar to ./sb_app_docker/target/ (Dockerfile cannot access parent folder)\
3. docker-compose up
4. test Spring Boot MYSQL access with http://localhost:10000/testing ( demo-0.0.1-SNAPSHOT.jar will access mysql dummy_db.product thru JPA)