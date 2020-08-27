#!/bin/bash
NAMESPACE=$1
SERVICE=$2
SMTP="smtp://smtp.yoursmtp.com:587"
USER="youruser@yousmtp.com"
FROM="sender@yoursmtp.com"
TO="receiver@receivermail.com"
TRESHOLD=$3
#IF YOU WANT YOU CAN ADD grep -v something

POD=$(kubectl get po -n $NAMESPACE | grep $SERVICE | awk {'print $1'})
LOGS=$(kubectl logs -n $NAMESPACE $POD | tail -n 300)
sendMail(){
printf "To:$TO\nFrom:$FROM\nSubject: (DEBUG) $POD is restarted! .\n\n\n\n  $LOGS \n\n " > jobs-mail.txt
curl --ssl-reqd --url $SMTP --user $USER --mail-from $FROM   --mail-rcpt $TO --upload-file mail.txt --insecure
}
if [[ $DEBUG == "true" ]]
then
        if [[ $LOGS == *" "* ]] #IF LOGS HAS BLANK(FOR DEBUG-TEST)
        then
        echo "This pod would be deleted: " $POD
        sendMail
        fi
else
        if [[ $LOGS == *"$TRESHOLD"* ]]
        then
        kubectl delete pod -n $NAMESPACE $POD
        sendMail
        fi
fi
##IT CAN BE EXTEND AS WISH
