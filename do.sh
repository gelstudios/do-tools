#!/bin/bash
#digital ocean api utility

config=do.conf

function load_config(){
if [[ -n $YOUR_CLIENT_ID && -n $YOUR_API_KEY ]]; then
    :
elif [[ -a "$config" ]]; then
    source "$config"
else
    echo "YOUR_CLIENT_ID=_your_client_id_goes_here_">"$config"
    echo "YOUR_API_KEY=_your_api_key_goes_here_">>"$config"
    echo "FAILMAIL=email@host.tld">>"$config"
    echo "a sample config has been created in ""$config"
    exit
fi;
};
load_config

URL='https://api.digitalocean.com'
AUTH='client_id='$YOUR_CLIENT_ID'&api_key='$YOUR_API_KEY

function getdrops(){
	curl -s $URL'/droplets/?'$AUTH
}

function getimages(){
	if [[ $1 == global ]] ;then
		filter=global #DO provided images
	else
		filter=my_images #User created images/snapshots
	fi
	curl -s $URL'/images/?'$AUTH'&filter='$filter
}

function getkeys(){
	curl -s $URL'/ssh_keys/?'$AUTH
}

function getsizes(){
	curl -s $URL'/sizes/?'$AUTH
}

function getregions(){
	curl -s $URL'/regions/?'$AUTH
}

function showkey(){
	chkid $1
	SSH_KEY_ID=$1
	curl -s $URL'/ssh_keys/'$SSH_KEY_ID'/?'$AUTH
}

function getstatus(){
	chkid $1
	DROPLET_ID=$1
	curl -s $URL'/droplets/'$DROPLET_ID'/?'$AUTH
}

function start(){
	chkid $1
	DROPLET_ID=$1
	curl -s $URL'/droplets/'$DROPLET_ID'/power_on/?'$AUTH
}

function stop(){
	chkid $1
	DROPLET_ID=$1
	curl -s $URL'/droplets/'$DROPLET_ID'/shutdown/?'$AUTH
}

function kill(){
	chkid $1
	DROPLET_ID=$1
	curl -s $URL'/droplets/'$DROPLET_ID'/power_off/?'$AUTH
}

function destroy(){
	chkid $1
	DROPLET_ID=$1
	curl -s $URL'/droplets/'$DROPLET_ID'/destroy/?'$AUTH
}

function create(){
	chkid $1; chkid $2;	chkid $3; chkid $4; chkid $5;
	DROPLET_NAME=$1
	IMAGE_ID=$2
	SSH_KEY_ID1=$3
	SIZE_ID=$4
	REGION_ID=$5
	curl -s $URL'/droplets/new?name='$DROPLET_NAME'&size_id='$SIZE_ID'&image_id='$IMAGE_ID'&region_id='$REGION_ID'&'$AUTH'&ssh_key_ids='$SSH_KEY_ID1
}

function chkid(){
if [[ -z $1 ]]; then
	echo "an ID or NAME is required"
	exit 1
fi
}

function getid(){
NAME=$1
INPUT=$2
REGEX='"id":([0-9]+),"name":"'"$NAME"'"'
if [[ $INPUT =~ $REGEX ]];then
	echo "${BASH_REMATCH[1]}"
else
	echo "$NAME not found"
	#exit 1
fi
}

function getprop(){
KEY=$1
INPUT=$2
REGEX='^.+"OK".+"'$KEY'":([a-zA-Z0-9".]+)'
if [[ $INPUT =~ $REGEX ]];then
	echo "${BASH_REMATCH[1]}"
else
	echo "$KEY not found"
	#exit 1
fi
}

case "$1" in
	getdrops|getimages|getkeys|getregions|getsizes|showkey|start|stop|kill|create|destroy )
	"$@"
	;;
	status )
	getstatus $2
	;;
	import )
	:
	;;
	* )
	echo "Usage: $0  {getdrops|getimages [global]|getkeys|getregions|getsizes}"
	echo "		{create} DROPLET_NAME IMAGE_ID SSH_KEY_ID SIZE_ID REGION_ID"
	echo "		{showkey} SSH_KEY_ID"
	echo "		{status|start|stop|kill|destroy} DROPLET_ID"
	echo
	echo "a CLIENT_ID and API_KEY are required a sample file will be created" 
	echo "a DROPLET_ID is required for any action affecting a specific host"
	exit 1
esac
