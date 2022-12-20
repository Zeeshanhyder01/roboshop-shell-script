#!/usr/bin/env bash

curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo
yum install -y mongodb-org
systemctl enable mongod
systemctl start mongod

#Update Listen IP address from 127.0.0.1 to 0.0.0.0 in config file
#Config file: `/etc/mongod.conf`

sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf

systemctl restart mongod
# Every Database needs the schema to be loaded for the application to work Download the schema and load it.

curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"
cd /tmp
unzip mongodb.zip
cd mongodb-main
mongo <catalogue.js
mongo <users.js

