#!/usr/bin/env bash
source components/common.sh
CHECK_ROOT

PRINT " CONFIGURE YUM REPO FOR REDIS:"
curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>${LOG}
CHECK_STAT $?

PRINT " INSTALLING REDIS "
yum install redis-6.2.13 -y  &>>${LOG}
CHECK_STAT $?

PRINT "UPDATE REDIS CONFIGURATION "
sed -i -e's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>${LOG}
CHECK_STAT $?

PRINT "START REDIS SERVICE"
systemctl enable redis &>>${LOG}  && systemctl start redis &>>${LOG}
CHECK_STAT $?