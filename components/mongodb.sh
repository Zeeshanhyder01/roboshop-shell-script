#!/usr/bin/env bash
source components/common.sh
CHECK_ROOT

PRINT "CONFIGURE YUM REPOS"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>${LOG}
CHECK_STAT $?

PRINT " INSTALL MONGODB"
yum install -y mongodb-org  &>>${LOG}
CHECK_STAT $?

PRINT "MONGODB CONFIGURATION"
sed -i -e's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
CHECK_STAT $?

PRINT "START MONGODB"
systemctl enable mongod &>>${LOG} && systemctl start mongod &>>${LOG} && systemctl restart mongod &>>${LOG}
CHECK_STAT $?

PRINT "DOWNLOAD SCHEMA"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>${LOG}
CHECK_STAT $?

PRINT " LOAD SCHEMA "
cd /tmp && unzip -o mongodb.zip  &>>${LOG} && cd mongodb-main && mongo < catalogue.js &>>${LOG} && mongo < users.js &>>${LOG}
CHECK_STAT $?



