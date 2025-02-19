#!/bin/bash

source ./common.sh
access_check

echo "Please enter the DB account password"
read -s Password

dnf module disable nodejs -y &>>$log
validation $? "Disabling of Nodejs version 18"

dnf module enable nodejs:20 -y &>>$log
validation $? "Enabling of Nodejs version 20"

dnf install nodejs -y &>>$log
validation $? "Installation of Nodejs version 20"

id expense &>>$log

if [ $? -ne 0 ]
    then
        useradd expense &>>$log
        validation $? "Addition of Expense user"
    else
        echo "Expense user is already available"
fi

rm -rf /app/

mkdir /app/ &>>$log
validation $? "app directory creation"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$log
validation $? "Code Download from internet"

cd /app &>>$log
validation $? "Moving inside app directory"

unzip /tmp/backend.zip &>>$log
validation $? "Unzipping the source code"

cd /app &>>$log
npm install &>>$log
validation $? "Installation of denpendent softwares"

cp /home/ec2-user/expense-shell/backend.service /etc/systemd/system/backend.service &>>$log
validation $? "Copying backend.service file"

systemctl daemon-reload &>>$log
validation $? "Deamon Reload"

systemctl start backend &>>$log
validation $? "Starting the backend serevice"

systemctl enable backend &>>$log
validation $? "Enabling backend serevice"

dnf install mysql -y &>>$log
validation $? "Installation of mysql client"

mysql -h db.cloudevops.online -uroot -p$Password < /app/schema/backend.sql &>>$log
validation $? "Running the SQL script"

systemctl restart backend &>>$log
validation $? "Restarting the backend serevice"