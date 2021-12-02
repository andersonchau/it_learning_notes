drop database IF EXISTS dummy_db;
create DATABASE dummy_db;

# create user here...
use dummy_db;

create table dummy_table (
	id INT(20) NOT NULL AUTO_INCREMENT,
	name varchar(255), 
	PRIMARY KEY (id)
);
INSERT INTO dummy_table (name) VALUES('achau');
create table product(
	id INT(20) NOT NULL AUTO_INCREMENT,
	name varchar(255), 
	PRIMARY KEY (id)
);

INSERT INTO product (name) VALUES('coke');


create user 'dummy_db'@'%' identified by 'morning';
grant all privileges on dummy_db.* to 'dummy_db'@'%' identified by 'morning';
grant all privileges on dumm_db.* to 'dummy_db'@'localhost' identified by 'morning'; 
