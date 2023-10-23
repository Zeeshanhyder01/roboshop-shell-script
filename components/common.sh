#!/usr/bin/env bash
CHECK_ROOT(){
  USER_ID=$(id -u)
  if [ $USER_ID -ne 0 ] ; then
  echo -e "\e[31m you should run this script as a root user or you can use sudo\e[0"
  exit 1
  fi
}

CHECK_STAT(){
echo "-------------------"
  if [ $1 -ne 0 ] ; then
    echo -e "\e[31m  FAILED \e[0m"
    echo -e "\n check log file  -$(LOG) for errors \n"
      exit 2
    else
      echo -e "\e[32m SUCCESS \e[0m"

  fi
}

LOG=/tmp/roboshop.log
rm -rf $LOG

PRINT() {
  echo "----------$1---------"
  echo "$1"
}
#
#NODEJS() {
#CHECK_ROOT
#
#printf "SETTING UP THE NODEJS YUM REPO IS"
#curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>>${LOG}
#CHECK_STAT $?
#
#printf "Installing NODEJS YUM REPO"
#yum install nodejs -y  &>>${LOG}
#CHECK_STAT $?
#
#printf "creating an Application user"
#id roboshop &>>${LOG}
#if [ $? -ne 0 ] ; then
#  useradd roboshop &>>${LOG}
#  fi
#CHECK_STAT $?
#
#printf "Downloading  ${COMPONENT} content"
#curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip"  &>>${LOG}
#CHECK_STAT $?
#
#cd /home/roboshop
#printf "Remove OLD content"
#rm -rf ${COMPONENT} &>>${LOG}
#CHECK_STAT $?
#
#printf "unzipping / extract cart content"
#unzip /tmp/${COMPONENT}.zip &>>${LOG}
#CHECK_STAT $?
#
#mv ${COMPONENT}-main ${COMPONENT}
#cd cart
#printf "Install NODEJS Dependencies for cart Component"
#npm install &>>${LOG}
#CHECK_STAT $?
#
#printf "Update systemd Configuration"
#sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' /etc/systemd/system/${COMPONENT}.service &>>${LOG}
#CHECK_STAT $?
#
#printf "SetUp systemd Configuration"
#mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service  &>>${LOG}
#CHECK_STAT $?
#
#systemctl daemon-reload
#systemctl enable ${COMPONENT} &>>${LOG}
#printf "start ${COMPONENT} service"
#systemctl restart ${COMPONENT}  &>>${LOG}
#}