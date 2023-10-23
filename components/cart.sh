#!/usr/bin/env bash
source components/common.sh
CHECK_ROOT
printf "SETTING UP THE NODEJS YUM REPO IS"
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>>${LOG}
CHECK_STAT $?

printf "Installing NODEJS YUM REPO"
yum install nodejs -y  &>>${LOG}
CHECK_STAT $?

printf "creating an Application user"
id roboshop &>>${LOG}
if [ $? -ne 0 ] ; then
  useradd roboshop &>>${LOG}
  fi
CHECK_STAT $?

printf "Downloading  ${COMPONENT} content"
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip"  &>>${LOG}
CHECK_STAT $?

cd /home/roboshop
printf "Remove OLD content"
rm -rf ${COMPONENT} &>>${LOG}
CHECK_STAT $?

printf "unzipping / extract cart content"
unzip /tmp/${COMPONENT}.zip &>>${LOG}
CHECK_STAT $?

mv ${COMPONENT}-main ${COMPONENT}
cd cart
printf "Install NODEJS Dependencies for cart Component"
npm install &>>${LOG}
CHECK_STAT $?

printf "Update systemd Configuration"
sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' /etc/systemd/system/${COMPONENT}.service &>>${LOG}
CHECK_STAT $?

printf "SetUp systemd Configuration"
mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service  &>>${LOG}
CHECK_STAT $?

systemctl daemon-reload
systemctl enable ${COMPONENT} &>>${LOG}
printf "start ${COMPONENT} service"
systemctl restart ${COMPONENT}  &>>${LOG}





