#!/usr/bin/env bash
# Installing Nginx for frontend
yum install nginx -y
systemctl enable nginx
systemctl start nginx