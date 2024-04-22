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



if [ $USERID -ne 0 ]
then
  echo -e "$R run with root acces"$N 
  exit 1
else
  echo -e "$Y running with root acces$N"
fi

dnf install nginx -y &>>$LOGFILE
  VALIDATE $? "insatlling nginx"

systemctl enable nginx &>>$LOGFILE
  VALIDATE $? "enable nginx"

systemctl start nginx &>>$LOGFILE
  VALIDATE $? "started nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE
  VALIDATE $? "old content nginx"

cd /usr/share/nginx/html
unzip /tmp/frontend.zip



cp /home/ec2-user/expense-shell/expense.conf /etc/nginx/default.d/expense.conf  &>>$LOGFILE
VALIDATE $? "configuration  file copied"



systemctl restart nginx &>>$LOGFILE
  VALIDATE $? "started nginx"