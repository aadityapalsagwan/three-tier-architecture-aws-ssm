# 🚀 Secure & Scalable Three-Tier AWS Architecture

## 📌 Project Overview

This project demonstrates a **Three-Tier Architecture on AWS** with high availability and security using:

* Web Tier (Public Subnet)
* App Tier (Private Subnet)
* Database Tier (Private Subnet)

---

## 🏗️ Architecture

![Architecture](architecture/architecture-diagram.png)

---

## 🌐 Network Configuration

### VPC

* CIDR: `10.0.0.0/16`

### Subnets (6 Total)

#### Public Subnets (Web Layer)

* public-web-subnet-AZ-1 → `10.0.0.0/24`
* public-web-subnet-AZ-2 → `10.0.10.0/24`

#### Private App Subnets

* private-app-subnet-AZ-1 → `10.0.20.0/24`
* private-app-subnet-AZ-2 → `10.0.30.0/24`

#### Private DB Subnets

* private-db-subnet-AZ-1 → `10.0.40.0/24`
* private-db-subnet-AZ-2 → `10.0.50.0/24`

---

## ⚙️ Services Used

* EC2 (Web & App Layer)
* Elastic Load Balancer
* Amazon Aurora (DB)
* S3 (Code Storage)
* IAM (Role-based access)
* SSM Session Manager (No SSH key used)

---

## 🔐 IAM & S3 Setup

* Created IAM Role with:

  * `AmazonS3ReadOnlyAccess`
  * `AmazonSSMManagedInstanceCore`

* Uploaded application code to S3 bucket

* Instances accessed S3 using IAM Role (no access keys used)

---

## 🔌 Connectivity

* No SSH Key used ❌
* All instances connected via **SSM Session Manager** ✅

---

## 🌍 Web Tier Setup

```bash
sudo amazon-linux-extras install nginx1 -y
cd /etc/nginx
ls
sudo rm nginx.conf
sudo aws s3 cp s3://3tierprojects/nginx.conf .
sudo systemctl start nginx
sudo systemctl enable nginx
chmod -R 755 /home/ec2-user
sudo chkconfig nginx on
```

---

## ⚙️ App Tier Setup

```bash
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
```

---

## 🗄️ Database Setup (Aurora)

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
```

---

## 📦 S3 Usage

* Uploaded code from local system → S3 bucket
* EC2 instances pulled code from S3

---

## 🎯 Key Features

* Highly Available (Multi-AZ)
* Secure (Private Subnets for App & DB)
* No SSH (SSM Based Access)
* Scalable Architecture

---

## 🎥 Project Demo

(Add your screen recording link here)

---

## 📸 Screenshots

(Add all step-by-step screenshots in /screenshots folder)

---

## 👨‍💻 Author

Aaditya Pal





# File Structure:

three-tier-aws-architecture/
│
├── README.md
├── architecture/
│   ├── architecture-diagram.png   (your image)
│   └── recording-link.txt         (optional: Google Drive / YouTube link)
│
├── scripts/
│   ├── web-tier-setup.sh
│   ├── app-tier-setup.sh
│   └── db-setup.sql
│
├── docs/
│   ├── vpc-details.md
│   ├── subnet-details.md
│   └── iam-s3-setup.md
│
└── screenshots/
    ├── step1.png
    ├── step2.png
    └── ...


