# #!/bin/bash.

# #know about userid to validate root acces required or not
# USERID=$(id -u)
# TIMESTAMP=$(date +%F-%H-%M-%S)
# SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
# LOGFILE=/tmp/$USERID-$TIMESTAMP-$SCRIPT_NAME.log

# #colours declaration
# R="e\[31m"
# G="e\[32m"
# Y="e\[33m"


# #function to keep code dry decalaring variables
# VALIDATE () {
# if [ $1 -ne 0 ]
# then
#  echo -e $2.....$R "script failure" $N
#  exit 1
# else
# echo -e $2.....$G "script passed" $N
# fi
# }



# if [ $USERID -ne 0 ]
# then
#   echo -e "$R run with root acces$N"
#   exit 1
# else
#   echo -e "$Y running with root acces$N"
# fi

# dnf install nginx -y &>>$LOGFILE
#   VALIDATE $? "insatlling nginx"

# systemctl enable nginx &>>$LOGFILE
#   VALIDATE $? "enable nginx"

# systemctl start nginx &>>$LOGFILE
#   VALIDATE $? "started nginx"

# rm -rf /usr/share/nginx/html/* &>>$LOGFILE
#   VALIDATE $? "old content nginx"

# curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip  &>>$LOGFILE
#   VALIDATE $? "new content nginx"

# cd /usr/share/nginx/html  &>>$LOGFILE
#   VALIDATE $? " removed nginx"
# unzip /tmp/frontend.zip  &>>$LOGFILE
#   VALIDATE $? " unzip nginx"



# cp /home/ec2-user/expense-shell/expense.conf /etc/nginx/default.d/expense.conf  &>>$LOGFILE
# VALIDATE $? "configuration  file copied"



# systemctl restart nginx &>>$LOGFILE
#   VALIDATE $? "started nginx"




#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
   if [ $1 -ne 0 ]
   then
        echo -e "$2...$R FAILURE $N"
        exit 1
    else
        echo -e "$2...$G SUCCESS $N"
    fi
}

if [ $USERID -ne 0 ]
then
    echo "Please run this script with root access."
    exit 1 # manually exit if error comes.
else
    echo "You are super user."
fi

dnf install nginx -y &>>$LOGFILE
VALIDATE $? "Installing nginx"

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "Enabling nginx"

systemctl start nginx &>>$LOGFILE
VALIDATE $? "Starting nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE
VALIDATE $? "Removing existing content"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE
VALIDATE $? "Downloading frontend code"

cd /usr/share/nginx/html &>>$LOGFILE
unzip /tmp/frontend.zip &>>$LOGFILE
VALIDATE $? "Extracting frontend code"

#check your repo and path
cp /home/ec2-user/expense-shell/expense.conf /etc/nginx/default.d/expense.conf &>>$LOGFILE
VALIDATE $? "Copied expense conf"

systemctl restart nginx &>>$LOGFILE
VALIDATE $? "Restarting nginx"