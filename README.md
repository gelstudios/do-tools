do-tools
========

Digital Ocean API utility:

Usage: ./do.sh <command> <args>

getdrops - returns a json list of all provisioned droplets

getimages [global] - returns a json list of an account's snapshots (system images). 'global' option returns images available globally

getkeys - returns an account's configured SSH_KEY_ID and SSH_KEY_NAME
showkey <SSH_KEY_ID> - returns an ssh public key for a given SSH_KEY_ID

getregions - returns available regions

getsizes - returns available droplet sizes

create DROPLET_NAME IMAGE_ID SSH_KEY_ID SIZE_ID REGION_ID

Droplet management options:

status <DROPLET_ID> - returns the status of a given DROPLET_ID
start <id> - sends a power on request
stop <id> - sends a shutdown request (graceful?)
kill <id> - sends a power off request (like pulling the plug)
destroy <id> - sends a request to immediately stop and delete a DROPLET_ID

"a CLIENT_ID and API_KEY are required a sample file will be created
"a DROPLET_ID is required for any action affecting a specific host