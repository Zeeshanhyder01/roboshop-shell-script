#!/usr/bin/env bash
CHECK_ROOT()
{
  USER_ID=$(id -u)
  if [ $USER_ID -ne 0 ]; then
    echo You are Non root user
    echo You can Run this script using sudo
    exit 1

  fi
}
CHECK_ROOT
