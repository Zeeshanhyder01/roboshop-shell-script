#!/usr/bin/env bash
source components/common.sh
CHECK_ROOT
echo Installing Nginx
yum install nginx -y
systemctl enable nginx
systemctl start nginx
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/static/* .
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf
sed -i -e'/catalogue/ s/localhost/catalogue.roboshop.internal/' /etc/nginx/default.d/roboshop.conf
sed -i -e'/user/ s/localhost/user.roboshop.internal/' /etc/nginx/default.d/roboshop.conf
sed -i -e'/cart/ s/localhost/cart.roboshop.internal/' /etc/nginx/default.d/roboshop.conf
sed -i -e'/shipping/ s/localhost/shipping.roboshop.internal/' /etc/nginx/default.d/roboshop.conf
sed -i -e'/payment/ s/localhost/payment.roboshop.internal/' /etc/nginx/default.d/roboshop.conf

systemctl restart nginx

