#!/usr/bin/env bash
source components/common.sh
CHECK_ROOT
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash &>>${LOG}
yum install nodejs -y
if [ &? -ne 0 ]; then
  echo "/e[31 m Setting up Node js YUM  Repo is FAILURE /e[0m"
  exit 2
fi
useradd roboshop
curl -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/user/archive/main.zip"
cd /home/roboshop
rm -rf user
unzip /tmp/user.zip
mv user-main user
cd /home/roboshop/user
npm install

sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' /home/roboshop/user/systemd.service
sed -i -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' /home/roboshop/user/systemd.service

mv /home/roboshop/user/systemd.service /etc/systemd/system/user.service
systemctl daemon-reload
systemctl restart user
systemctl enable user
