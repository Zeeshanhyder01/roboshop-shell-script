#!/usr/bin/env bash

CHECK_ROOT(){
  USER_ID=$(id -u)
  if [ $USER_ID -ne 0 ] ; then
  echo you are non root user
  echo you can run this scrpit as a root user or use sudo
  exit 1
  fi
}