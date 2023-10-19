#!/usr/bin/env bash
yum install python36 gcc python3-devel -y
useradd roboshop
cd /home/roboshop
rm -rf payment
curl -L -s -o /tmp/payment.zip "https://github.com/roboshop-devops-project/payment/archive/main.zip"
unzip /tmp/payment.zip
mv payment-main payment
cd /home/roboshop/payment
pip3 install -r requirements.txt

USER_ID=$(id -u roboshop)
GROUP-ID=$(id -g roboshop)

sed -i -e"/^uid/ uid = ${USER_ID}" -e "/^gid/ gid = ${GROUP_ID}"  /home/roboshop/payment/payment.ini

#
#    Update `CARTHOST` with cart server ip
#
#    Update `USERHOST` with user server ip
#
#    Update `AMQPHOST` with RabbitMQ server ip.
#
#3. Setup the service
# mv /home/roboshop/payment/systemd.service /etc/systemd/system/payment.service
# systemctl daemon-reload
# systemctl enable payment
# systemctl start payment