#declare shebang
#!/bin/bash

#know about userid to validate root acces required or not
USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOGFILE=/tmp/$USERID-$TIMESTAMP-$SCRIPT_NAME.log

#colours declaration
R="e\[31m"
G="e\[32m"
Y="e\[33m"

#password should not hard code
echo "please enter DB password:"
read  mysql_root_password


#function to keep code dry decalaring variables
VALIDATE () {
if [ $1 -ne 0 ]
then
 echo -e $2.....$R "script failure" $N
 exit 1
else
echo -e $2.....$G "script passed" $N
fi
}

dnf module disable nodejs -y &>>$LOGFILE
 VALIDATE $? "disabiling nodejs"

 dnf module enable nodejs:20 -y &>>$LOGFILE
 VALIDATE $? "enabeling nodejs"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "installing nodejs"

#useradd expense

id expense &>>$LOGFILE

if [ $? -ne 0 ]
then
echo "adding user"
else
echo "already user exist"
fi

#creating directory
mkdir -p /app &>>$LOGFILE
VALIDATE $? "directory created"

rm -rf /app/*

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip  &>>$LOGFILE
VALIDATE $? "backend content downlaoded"

cd /app &>>$LOGFILE
rm -rf /app/*

unzip /tmp/backend.zip &>>$LOGFILE
VALIDATE $? "backend content extracted"

npm install &>>$LOGFILE
VALIDATE $? "installed dependencies"

cp /home/ec2-user/expense-shell/backend.cervicefile  /etc/systemd/system/backend.service &>>$LOGFILE
VALIDATE $? "backend service file copied"

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "daemon reloaded"

systemctl start backend &>>$LOGFILE
VALIDATE $? "backend started"

systemctl enable backend &>>$
VALIDATE $? "enabled backend"

dnf install mysql -y  &>>$LOGFILE
VALIDATE $? "mysql clinet insatlled"

mysql -h 172.31.29.94 -uroot -p${mysql_root_password} < /app/schema/backend.sql  &>>$LOGFILE
VALIDATE $? "password passed"


systemctl restart backend  &>>$LOGFILE
VALIDATE $? "backend restarted"




