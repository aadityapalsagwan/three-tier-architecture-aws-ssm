#!/bin/bash
# This script sets up the web tier for the application.

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


# Start by installing NVM (node version manager).

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
source ~/.bashrc

# Next, install a compatible version of Node.js:
nvm install 16
nvm use 16

# PM2 is a daemon process manager that will keep our node.js app running in the background. It will also automatically restart the app if it crashes.:
npm install -g pm2   

# download our code from our s3 buckets onto our instance:
cd ~/
aws s3 cp s3://BUCKET_NAME/app-tier/ app-tier --recursive

# Navigate to the app directory, install dependencies, and start the app with pm2.:
cd ~/app-tier
npm install
pm2 start index.js

# pp is running correctly run the following:
pm2 list

# status of online, the app is running. If you see errored, then you need to do some troubleshooting.
pm2 logs

# Right now, pm2 is just making sure our app stays running when we leave the SSM session:
pm2 startup

# After running this you will see a message:
sudo env PATH=$PATH:/home/ec2-user/.nvm/versions/node/v16.0.0/bin /home/ec2-user/.nvm/versions/node/v16.0.0/lib/node_modules/pm2/bin/pm2 startup systemd -u ec2-user —hp /home/ec2-user


pm2 save

# hit out health check endpoint, copy:
curl http://localhost:4000/health

# test your database connection. You can do that by hitting the following endpoint locally:
curl http://localhost:4000/transaction