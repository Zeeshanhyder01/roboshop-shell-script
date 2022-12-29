#!/usr/bin/env bash
source components/common.sh

yum install maven -y
useradd roboshop
cd /home/roboshop
curl -s -L -o /tmp/shipping.zip "https://github.com/roboshop-devops-project/shipping/archive/main.zip"
unzip /tmp/shipping.zip
mv shipping-main shipping
cd shipping
mvn clean package
mv target/shipping-1.0.jar shipping.jar
sed -i -e "s/CARTENDPOINT/cart.roboshop.internal/" /home/roboshop/shipping/systemd.service
sed -i -e "s/DBHOST/mysql.roboshop.internal/" /home/roboshop/shipping/systemd.service
#1. Update SystemD Service file
# Update `CARTENDPOINT` with Cart Server IP.
#Update `DBHOST` with MySQL Server IP

mv /home/roboshop/shipping/systemd.service /etc/systemd/system/shipping.service
systemctl daemon-reload
systemctl restart shipping
systemctl enable shipping