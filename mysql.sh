#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/expense-logs"
LOG_FILE=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE_NAME="$LOGS_FOLDER/$LOG_FILE-$TIMESTAMP.LOG"




validate(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2 ...  $R failure $N"
        exit 1
    else
        echo -e "$2 ... $G success $N"
    fi
}


check_root(){
if [ $USERID -ne 0 ]
then
    echo "ERROR:: you must have sudo access to execute this script"
    exit 1
fi
}

echo "script started executing at: $TIMESTAMP" &>>$LOG_FILE_NAME

check_root

dnf install mysql-server -y &>>$LOG_FILE_NAME
validate $? "installing mysql server"

systemctl enable mysqld &>>$LOG_FILE_NAME
validate $? "enabling mysql server"

systemctl start mysqld &>>$LOG_FILE_NAME
validate $? "starting mysql server"

mysql_secure_installation --set-root-pass ExpenseApp@1
validate $? "setting root password"