#!/bin/bash

source ./common.sh

echo "Please enter DB password"
read -s Password

dnf install mysql-server -y &>>$log
validation $? "Installation of MySQL"

systemctl enable mysqld &>>$log
validation $? "Enabling MySQL service"

systemctl start mysqld &>>$log
validation $? "Staring of MySQL service"

mysql_secure_installation --set-root-pass $Password &>>$log
validation $? "Setting of root user password"