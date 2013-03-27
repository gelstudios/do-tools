#!/bin/bash
#donut- build a node
######

if [[ -z $1 ]]; then #if no args, use these defaults!
	DROPNAME=deploy
	IMGNAME=hnbot
	KEYNAME=threepio
	SIZENAME=512GB
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
SIZEID=`getid "$SIZENAME" "$SIZEID"`

echo
echo `date`
echo "creating droplet: $DROPNAME"
create $DROPNAME $IMGID $SSHID $SIZEID $REGION

#^^^shjould capture this response to get id
#below 'getdrops' method wont work well with duplicate node names, which are allowed

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
	if [[ "$STATUS" =~ "active" || "$STATUS" =~ "new" ]]; then
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
		exit 1
	fi
done;
