#!/bin/bash
PROTOCOL="https" # http or https (should be https on port 7071
PORT="7071"
SERVER="mail.example.com" # mail store server
DOMAIN="example.com" #
FOLDER="/path/to/your/backupfolder"
TEMPFOLDER="/tmp"
FMT="zip" # format can be zip or tgz

# User credentials of an admin account
USER="admin@mail.example.com"
PWD="<PASSWORD>"

for account in $(/usr/bin/sudo -u zimbra /opt/zimbra/bin/zmprov -l gaa $DOMAIN|sort -R);
do
if [ ! -f $FOLDER/$account.$FMT ]; then
	echo "Backing up $account to $FOLDER/$account.$FMT"
	curl -s -u $USER:$PWD "$PROTOCOL://$SERVER:$PORT/home/$account/?fmt=$FMT" > $TEMPFOLDER/$account.$FMT
	mv $TEMPFOLDER/$account.$FMT $FOLDER/$account.$FMT
fi
done
