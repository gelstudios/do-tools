#!/bin/bash
#sleepy giant job runner
######

KEYNAME=threepio
IMGNAME=hnbot
DROPNAME=deploy
SIZE=62
REGION=1

if [[ -n $FAILMAIL ]]; then
    :
else
    FAILMAIL='user@host.tld'
fi;

######

source do.sh import

SSHID=`getid $KEYNAME \`getkeys\``
IMGID=`getid hnbot \`getimages\``

echo `date`
echo
echo "creating droplet $DROPNAME"
create $DROPNAME $IMGID $SSHID $SIZE $REGION

echo
echo "getting droplet id for $DROPNAME"
DROPID=`getid $DROPNAME \`getdrops\``

echo "waiting for droplet $DROPNAME ($DROPID) to provision."
while true; do
	sleep 10
	STATUS=`status $DROPID`
	STATUS=`getprop status $STATUS`
	if [[ $STATUS =~ "new" ]]; then
		echo "getting droplet ip for $DROPNAME"
		DROPIP=`status $DROPID`
		DROPIP=`getprop ip_address $DROPIP`
		echo "ip: $DROPIP"
		break
	else
		echo -n "."
	fi
done;

echo "waiting for droplet $DROPNAME ($DROPID) to shut down."
while true; do
	sleep 10
	STATUS=`status $DROPID`
	STATUS=`getprop status $STATUS`
	if [[ $STATUS =~ "off" ]]; then
		echo "destroying $DROPNAME"
		destroy $DROPID
		break
	else
		echo -n "."
	fi
done;

echo "checking for droplet $DROPNAME ($DROPID)."
dd=0
while true; do
	sleep 10
	STATUS=`status $DROPID`
	if [[ $STATUS =~ "ERROR" || $STATUS =~ "archive" ]]; then
		echo "confirmed destroyed"
		break
	elif [[ $dd -le 10 ]]; then
		echo -n "."
		(( dd++ ))
	else
		echo "possible runaway, sending alert email"
		echo "DigitalOcean droplet $DROPNAME ($DROPID) $DROPIP failed to stop" | mail -s "FAILURE" "$FAILMAIL"
		break
	fi
done;
