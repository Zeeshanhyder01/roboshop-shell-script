#!/usr/bin/env bash
source components/common.sh
CHECK_ROOT

echo -e "\e[31m SETTING UP THE NODEJS YUM REPO IS \e[0m"
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>>${LOG}
CHECK_STAT $?

echo Installing NODEJS YUM REPO
yum install nodejs -y  &>>${LOG}
CHECK_STAT $?

echo  creating an Application user
useradd roboshop &>>${LOG}
CHECK_STAT $?

echo  Downloading  cart content
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip"  &>>${LOG}
CHECK_STAT $?

cd /home/roboshop
echo Remove OLD content
rm -rf cart &>>${LOG}
CHECK_STAT $?

echo  unzipping / extract cart content
unzip /tmp/cart.zip &>>${LOG}
CHECK_STAT $?

mv cart-main cart
cd cart
echo  Install NODEJS Dependencies for cart Component
npm install &>>${LOG}
CHECK_STAT $?

echo  Update systemd Configuration
sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' /etc/systemd/system/cart.service &>>${LOG}
CHECK_STAT $?

echo SetUp systemd Configuration
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service  &>>${LOG}
CHECK_STAT $?

systemctl daemon-reload
systemctl enable cart
echo start cart service
systemctl restart cart  &>>${LOG}

