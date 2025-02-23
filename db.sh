#!/bin/bash

source ./common.sh
access_check

echo "Please enter DB password"
read -s Password

dnf install mysql-server -y &>>$log
validation $? "Installation of MySQL"

systemctl enable mysqld &>>$log
validation $? "Enabling MySQL service"

systemctl start mysqld &>>$log
validation $? "Staring of MySQL service"

# mysql_secure_installation --set-root-pass $Password &>>$log
# validation $? "Setting of root user password"

#Below code will be useful for idempotent nature
mysql -h db.cloudevops.online -uroot -p${Password} -e 'show databases;' &>>$log
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${Password} &>>$log
    VALIDATE $? "MySQL Root password Setup"
else
    echo -e "MySQL Root password is already setup...$Y SKIPPING $N"
fi