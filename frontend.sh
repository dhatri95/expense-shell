#!/bin/bash

source ./common.sh

access_check

dnf install nginx -y &>>$log
validation $? "Installation of Nginx"

systemctl enable nginx &>>$log
validation $? "Enabling the Nginx service"

systemctl start nginx &>>$log
validation $? "Starting the Nginx service"

rm -rf /usr/share/nginx/html/* &>>$log
validation $? "Removing default html pages"


curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$log
validation $? "Downloading source code"

cd /usr/share/nginx/html &>>$log

unzip /tmp/frontend.zip &>>$log
validation $? "Unzipping source code"

cp /home/ec2-user/expense-shell/expense.conf /etc/nginx/default.d/expense.conf &>>$log
validation $? "Copying Expense.conf file"

systemctl restart nginx &>>$log
validation $? "Restarting the Nginx service"