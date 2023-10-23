#!/usr/bin/env bash
source components/common.sh
CHECK_ROOT

printf "SETTING UP THE NODEJS YUM REPO IS"
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>>${LOG}
CHECK_STAT $?

PRINT "Installing NODEJS YUM REPO"
yum install nodejs -y  &>>${LOG}
CHECK_STAT $?

PRINT "creating an Application user"
id roboshop &>>${LOG}
if [ $? -ne 0 ] ; then
  useradd roboshop &>>${LOG}
  fi
CHECK_STAT $?

PRINT  "Downloading  cart content"
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip"  &>>${LOG}
CHECK_STAT $?

cd /home/roboshop
PRINT "Remove OLD content"
rm -rf cart &>>${LOG}
CHECK_STAT $?

PRINT  "unzipping / extract cart content"
unzip /tmp/cart.zip &>>${LOG}
CHECK_STAT $?

mv cart-main cart
cd cart
PRINT  "Install NODEJS Dependencies for cart Component"
npm install &>>${LOG}
CHECK_STAT $?

PRINT  "Update systemd Configuration"
sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' /etc/systemd/system/cart.service &>>${LOG}
CHECK_STAT $?

PRINT "SetUp systemd Configuration"
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service  &>>${LOG}
CHECK_STAT $?

systemctl daemon-reload
systemctl enable cart
PRINT "start cart service"
systemctl restart cart  &>>${LOG}

