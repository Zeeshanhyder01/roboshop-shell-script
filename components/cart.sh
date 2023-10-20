#!/usr/bin/env bash
source components/common.sh
CHECK_ROOT

echo -e "\e[31m SETTING UP THE NODEJS YUM REPO IS \e[0m"
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>>${LOG}
CHECK_STAT $?

echo -e "\e[31m Installing NODEJS YUM REPO  \e[0m"
yum install nodejs -y  &>>${LOG}
CHECK_STAT $?

echo -e "\e[33m creating an Application user \e[0m"
useradd roboshop &>>${LOG}
CHECK_STAT $?

echo -e "\e[34m Downloading  cart content \e[0m"
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip"  &>>${LOG}
CHECK_STAT $?

cd /home/roboshop
echo -e "\e[31m Remove OLD content \e[0m"
rm -rf cart &>>${LOG}
CHECK_STAT $?

echo -e "\e[33m unzipping / extract cart content\e[0m"
unzip /tmp/cart.zip &>>${LOG}
CHECK_STAT $?

mv cart-main cart
cd cart
echo -e "\e[31m Install NODEJS Dependencies for cart Component\e[0m"
npm install &>>${LOG}
CHECK_STAT $?

echo -e "\e[31m Update systemd Configuration \e[0m"
sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' /etc/systemd/system/cart.service &>>${LOG}
CHECK_STAT $?

echo -e "\e[31m SetUp systemd Configuration \e[0m"
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service  &>>${LOG}
CHECK_STAT $?

systemctl daemon-reload
systemctl enable cart

echo -e "\e[31m start cart service \e[0"
systemctl restart cart  &>>${LOG}

