#!/usr/bin/env bash
CHECK_ROOT(){
  USER_ID=$(id -u)
  if [ $USER_ID -ne 0 ] ; then
  echo -e "\e[31m you should run this script as a root user or you can use sudo\e[0"
  exit 1
  fi
}

CHECK_STAT(){
  if [ $1 -ne 0 ] ; then
    echo -e "\e[31m  FAILED \e[0m"
    else
      echo -e "\e[32m SUCCESS \e[0m"
    exit 2
  fi
}


LOG=/tmp/roboshop.log
rm -rf $LOG
