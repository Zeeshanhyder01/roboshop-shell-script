#!/usr/bin/env bash
CHECK_ROOT(){
  USER_ID=$(id -u)
  if [ $USER_ID -ne 0 ] ; then
  echo -e "\e[31m you should run this script as a root user or you can use sudo\e[0"
  exit 1
  fi
}

CHECK_STAT(){
echo "-------------------" >>${LOG}
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
  echo "----------$1---------">>${LOG}
  echo "$1"
}


NODEJS() {
  CHECK_ROOT
  PRINT "SETTING UP THE NODEJS YUM REPO IS"
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

  PRINT "Downloading ${COMPONENT} content"
  curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip"  &>>${LOG}
  CHECK_STAT $?

  cd /home/roboshop
  PRINT "Remove OLD content"
  rm -rf ${COMPONENT} &>>${LOG}
  CHECK_STAT $?

  PRINT "unzipping / extract ${COMPONENT} content"
  unzip /tmp/${COMPONENT}.zip &>>${LOG}
  CHECK_STAT $?

  mv ${COMPONENT}-main ${COMPONENT}
  cd ${COMPONENT}
  PRINT "Install NODEJS Dependencies for ${COMPONENT} Component"
  npm install &>>${LOG}
  CHECK_STAT $?

  PRINT "Update systemd Configuration"
  sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' -e 's/CARTHOST/cart.roboshop.internal/' -e 's/USERHOST/user.roboshop.internal/' -e 's/AMQPHOST/rabbitmq.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service &>>${LOG}
  CHECK_STAT $?

  PRINT "SetUp systemd Configuration"
  mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service  &>>${LOG}
  CHECK_STAT $?
  PRINT "start ${COMPONENT} service"
  systemctl enable ${COMPONENT} &>>${LOG} && systemctl restart ${COMPONENT}  &>>${LOG} && systemctl daemon-reload
  CHECK_STAT $?
}

NGINX(){
    CHECK_ROOT
    PRINT "Installing Nginx"
    yum install nginx -y &>>${LOG}
    CHECK_STAT $?

    PRINT "DOWNLOAD ${COMPONENT} Content"
    curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>${LOG}
    CHECK_STAT $?
    PRINT "clean old content"
    cd /usr/share/nginx/html
    rm -rf * &>>${LOG}
    CHECK_STAT $?
    PRINT "extract ${COMPONENT} content"
    unzip /tmp/${COMPONENT}.zip  &>>${LOG}
    CHECK_STAT $?
    PRINT " ORGANISE ${COMPONENT}  CONTENT"
    mv ${COMPONENT}-main/* . && mv static/* . && rm -rf ${COMPONENT}-main README.md && mv localhost.conf /etc/nginx/default.d/roboshop.conf
    PRINT " UPDATE ${COMPONENT} CONFIGURATION"
    sed -i -e '/catalogue/ s/localhost/catalogue.roboshop.internal/' -e '/user/ s/localhost/user.roboshop.internal/' -e '/cart/ s/localhost/cart.roboshop.internal/' -e '/payment/ s/localhost/payment.roboshop.internal/' -e '/shipping/ s/localhost/shipping.roboshop.internal/' /etc/nginx/default.d/roboshop.conf
    CHECK_STAT $?
    PRINT " START NGINX SERVICE "
    systemctl enable nginx &>>${LOG} && systemctl restart nginx  &>>${LOG}
    CHECK_STAT $?
}