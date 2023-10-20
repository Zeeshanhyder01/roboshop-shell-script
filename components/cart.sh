#!/usr/bin/env bash
source components/common.sh
CHECK_ROOT
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>>${LOG}
if [ $? -eq 0 ] ; then
  echo -e "\e[31m SETTING UP THE NODEJS REPO \e[0"
  exit 2
fi
yum install nodejs -y
useradd roboshop
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip"
cd /home/roboshop
rm -rf cart
unzip /tmp/cart.zip
mv cart-main cart
cd cart
npm install
sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' /etc/systemd/system/cart.service
sed -i -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' /etc/systemd/system/cart.service
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service
systemctl daemon-reload
systemctl start cart
systemctl enable cart
