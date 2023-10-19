#!/usr/bin/env bash

curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo
yum install mysql-community-server -y
systemctl enable mysqld
systemctl start mysqld
MYSQL_DEFAULT_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';" >/tmp/mysql
mysql --connect-expired-password -uRoot -p"${MYSQL_DEFAULT_PASSWORD}" < /tmp/mysql

#1. Now a default root password will be generated and given in the log file.
#
#```bash
## grep temp /var/log/mysqld.log
#```
#
#1. Next, We need to change the default root password in order to start using the database service. Use password `RoboShop@1` or any other as per your choice. Rest of the options you can choose `No`
#
#```bash
## mysql_secure_installation
#```
#
#1. You can check the new password working or not using the following command in MySQL
#
#First lets connect to MySQL
#
#```bash
## mysql -uroot -pRoboShop@1
#```
#
#Once after login to MySQL prompt then run this SQL Command.
#
#```sql
#> uninstall plugin validate_password;
#```
#
### **Setup Needed for Application.**
#
#As per the architecture diagram, MySQL is needed by
#
#- Shipping Service
#
#So we need to load that schema into the database, So those applications will detect them and run accordingly.
#
#To download schema, Use the following command
#
#```bash
## curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
#```
##
#Load the schema for Services