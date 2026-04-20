#!/bin/bash
# This script sets up the database tier for the application.
sudo -su ec2-user
ping 8.8.8.8

# Configure Database:
sudo yum install mysql -y | sudo yum install mariadb105 -y
mysql --version

# Initiate your DB connection with your Aurora RDS writer endpoint.:

mysql -h CHANGE-TO-YOUR-RDS-ENDPOINT -u admin -p

# Create a database called webappdb:
CREATE DATABASE webappdb;   
SHOW DATABASES;

# Create a data table:
USE webappdb;    

# create the following transactions:
CREATE TABLE IF NOT EXISTS transactions(id INT NOT NULL
AUTO_INCREMENT, amount DECIMAL(10,2), description
VARCHAR(100), PRIMARY KEY(id));    
SHOW TABLES;    

# Insert data into table for use/testing later:
INSERT INTO transactions (amount,description) VALUES ('400','groceries');   

# Verify that your data was added by executing the following command:
SELECT * FROM transactions;


# hit out health check endpoint, copy:
curl http://localhost:4000/health

# test your database connection. You can do that by hitting the following endpoint locally:
curl http://localhost:4000/transaction