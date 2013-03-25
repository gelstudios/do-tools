do-tools
========

Digital Ocean API utility:

Usage: ./do.sh <option>


getdrops - returns a json list of all provisioned droplets

getimages [global] - returns a json list of an account's snapshots (system images). 'global' option returns images available globally

getkeys - returns an account's configured SSH_KEY_ID and SSH_KEY_NAME
showkey <SSH_KEY_ID> - returns an ssh public key for a given SSH_KEY_ID

getregions - returns available regions

getsizes - returns available droplet sizes

create DROPLET_NAME IMAGE_ID SSH_KEY_ID SIZE_ID REGION_ID

Droplet management options:

status <DROPLET_ID>
start
stop
kill
destroy



"a CLIENT_ID and API_KEY are required a sample file will be created
"a DROPLET_ID is required for any action affecting a specific host