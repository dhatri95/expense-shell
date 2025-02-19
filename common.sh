Userid=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
timestamp=$(date +%F-%H-%M-%S)
ScriptName=$(echo $0 | cut -d "." -f 1)
log="/tmp/$ScriptName-$timestamp.log"

validation()
{
    if [ $1 -eq 0 ]
        then
            echo -e "$2.. $G SUCEEDED $N"
        else
            echo -e "$2.. $R FAILED $N"
    fi
}

access_check()
{
    if [ $Userid -eq 0 ]
    then
        echo -e "You are running scripts with SUDO Access"
    else
        echo -e "Please use SUDO access to run the script"
        exit 1
    fi
}

