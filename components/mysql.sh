#!/usr/bin/env bash
source components/common.sh
CHECK_ROOT

if [ -z "${MYSQL_PASSWORD}" ]; then
  else " NEED MYSQL_PASSWORD ENV VARAIABLE"
  exit 1
fi


PRINT "CONFIGURE YUM REPOS "
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>${LOG}
CHECK_STAT $?

PRINT " INSTALL MY SQL"
yum install mysql-community-server -y  &>>${LOG}
systemctl enable mysqld  &>>${LOG} && systemctl start mysqld  &>>${LOG}
CHECK_STAT $?

PRINT "RESET ROOT PASSWORD "
MYSQL_DEFAULT_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';" | mysql --connect-expired-password -uRoot -p"${MYSQL_DEFAULT_PASSWORD}" &>>${LOG}
CHECK_STAT $?
exit 2

echo "uninstall plugin validate_password;" | mysql -uroot -p"${MYSQL_PASSWORD}"

curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
cd /tmp
unzip -o mysql.zip
cd mysql-main
mysql -u root -p"${MYSQL_PASSWORD}" <shipping.sql

