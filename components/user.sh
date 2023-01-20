#!/usr/bin/env bash
source components/common.sh
CHECK_ROOT
echo -e "\e[33m Setting up Node js YUM  Repo is : \e[0m"
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash &>>${LOG}
CHECK_STAT $?

echo -e "\e[33m Installing NodeJs: \e[0m"
yum install nodejs -y &>>${LOG}
CHECK_STAT $?

echo -e "\e[33m Creating Application User \e[0m"
useradd roboshop &>>${LOG}
CHECK_STAT $?

echo -e "\e[33m Downloading User Content \e[0m"
curl -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/user/archive/main.zip" &>>${LOG}
CHECK_STAT $?
cd /home/roboshop
echo -e "\e[31m Removing Old Content \e[0m"
rm -rf user &>>${LOG}
CHECK_STAT $?

echo -e "\e[33m Extracting User Content \e[0m"
unzip /tmp/user.zip &>>${LOG}
CHECK_STAT $?

mv user-main user
cd /home/roboshop/user
echo -e "\e[33m Installing Node Js Dependencies for user component \e[0m"
npm install &>>${LOG}
CHECK_STAT $?

echo -e "\e[33m update Systemd configuration \e[0m"
sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' /home/roboshop/user/systemd.service &>>${LOG}
sed -i -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' /home/roboshop/user/systemd.service &>>${LOG}
CHECK_STAT $?

echo -e "\e[33m Setup Systemd Configuration \e[0m"
mv /home/roboshop/user/systemd.service /etc/systemd/system/user.service &>>${LOG}
CHECK_STAT $?
systemctl daemon-reload
systemctl enable user

echo -e "\e[33m Start user service \e[0m"
systemctl restart user &>>${LOG}
CHECK_STAT $?
