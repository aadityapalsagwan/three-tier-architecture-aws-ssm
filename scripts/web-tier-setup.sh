#!/bin/bash

# After the Connect to Instance :
sudo -su ec2-user 
ping 8.8.8.8

# Configure Web Instance :
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
source ~/.bashrc
nvm install 16
nvm use 16

# Import the Code from s3 bucket: 

cd ~/
aws s3 cp s3://3tierprojects/web-tier/ web-tier --recursive

# Navigate to the web-layer folder and create the build folder for the react app so we can serve our code:

cd ~/web-tier
npm install 
npm run build

# Install nginx to serve the react app:

sudo amazon-linux-extras install nginx1 -y
cd /etc/nginx
ls
sudo rm nginx.conf
sudo aws s3 cp s3://3tierprojects/nginx.conf .
sudo systemctl start nginx
sudo systemctl enable nginx
chmod -R 755 /home/ec2-user
sudo chkconfig nginx on
