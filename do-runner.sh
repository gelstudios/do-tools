#!/bin/bash
#sleepy giant job runner
#requires mail
######

if [[ -z $1 ]]; then #if no args, use these defaults!
	DROPNAME=deploy
	IMGNAME=hnbot
	KEYNAME=threepio
	SIZENAME=1GB
	REGION=1
else
	DROPNAME="$1"
	IMGNAME="$2"
	KEYNAME="$3"
	SIZENAME="$4"
	REGION="$5"
fi;

if [[ -n $FAILMAIL ]]; then
    :
else
    FAILMAIL="$USER@localhost"
fi;

######

source do.sh import

SSHID=`getkeys`
SSHID=`getid "$KEYNAME" "$SSHID"`

IMGID=`getimages`
IMGID=`getid "$IMGNAME" "$IMGID"`

SIZEID=`getsizes`
SIZEID=`getid "$SIZENAME" "$SIZEID"

echo
echo `date`
echo "creating droplet: $DROPNAME"
create $DROPNAME $IMGID $SSHID $SIZEID $REGION

echo
echo "getting droplet id for: $DROPNAME"
DROPID=`getdrops`
DROPID=`getid $DROPNAME "$DROPID"`

echo "waiting for droplet: $DROPNAME ($DROPID) to provision."
dd=0
while true; do
	sleep 10
	STATUS=`getstatus $DROPID`
	STATUS=`getprop status "$STATUS"`
	if [[ "$STATUS" =~ "new" ]]; then
		echo "getting droplet ip for: $DROPNAME"
		DROPIP=`getstatus $DROPID`
		DROPIP=`getprop ip_address "$DROPIP"`
		echo "ip: $DROPIP"
		break
	elif [[ $dd -le 30 ]]; then
		echo -n "."
		(( dd++ ))
	else
		echo "WARNING: possible provisioning failure"
	fi
done;

echo "waiting for droplet $DROPNAME ($DROPID) to shut down."
while true; do
	sleep 10
	STATUS=`getstatus $DROPID`
	STATUS=`getprop status "$STATUS"`
	if [[ "$STATUS" =~ "off" ]]; then
		echo
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
	STATUS=`getstatus $DROPID`
	if [[ "$STATUS" =~ "ERROR" || "$STATUS" =~ "archive" ]]; then
		echo "confirmed destroyed"
		break
	elif [[ $dd -le 10 ]]; then
		echo -n "."
		(( dd++ ))
	else
		echo "WARNING: possible runaway, sending alert email"
		echo "DigitalOcean droplet $DROPNAME ($DROPID) $DROPIP failed to stop" | mail -s "FAILURE" "$FAILMAIL"
		break
	fi
done;
echo "------"
#