#declare shebang
#!/bin/bash

#know about userid to validate root acces required or not
USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$( echo $0 | cut -d"."-f1 )
LOGFILE=/tmp/$USERID-$TIMESTAMP-$SCRIPT_NAME.log

#colours declaration
R="e\[31m"
G="e\[32m"
Y="e\[33m"

#function to keep code dry decalaring variables
VALIDATE () {
if [ $1 -ne 0 ]
then
 echo -e "$2.....$R script failure $N"
 exit 1
else
echo -e "$2......script passed $N"
fi
}



if [ $USERID -ne 0 ]
then
  echo -e $R"run with root acces"$N 
  exit 1
else
  echo -e "$Y running with root acces$N"
fi

dnf install mysql-server -y &>>$LOGFILE
  VALIDATE $? "insatlling mysql"

systemctl enable mysqld &>>$LOGFILE
 VALIDATE $? "enable mysql"

 systemctl start mysqld &>>$LOGFILE
  VALIDATE $? "start mysql"

mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
 VALIDATE $? "secure mysql"
