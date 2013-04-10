#!/usr/bin/env python
#adapted from https://www.digitalocean.com/api

import os, sys
try:
	import requests
except:
	print 'requests module is required'
	exit(1)

YOUR_CLIENT_ID = os.getenv('YOUR_CLIENT_ID')
YOUR_API_KEY = os.getenv('YOUR_API_KEY')

BASEURL = 'https://api.digitalocean.com/'
AUTH = {'client_id':YOUR_CLIENT_ID, 'api_key':YOUR_API_KEY}

def getdrops():
	"""returns a json string containing all droplets"""
	url = BASEURL + 'droplets'
	payload = AUTH
	req = requests.get(url, params=payload)
	return req.json()

def getimages(filter='my_images'):
	"""returns a json string of available images"""
	url = BASEURL + 'images'
	payload = AUTH
	if filter=='global':
		payload['filter']='global' #DO provided images/snapshots
	else:
		payload['filter']='my_images' #User created images/snapshot
	req = requests.get(url, params=payload)
	return req.json()

def getkeys():
	"""returns a json string of configured ssh keys"""
	url = BASEURL + 'ssh_keys'
	payload = AUTH
	req = requests.get(url, params=payload)
	return req.json()

def status(id):
	"""id, Required, Numeric, returns a json string with status for a given ID"""
	url = BASEURL + 'droplets/' + str(id)
	payload = AUTH
	req = requests.get(url, params=payload)
	return req.json()

def create(name, size_id, image_id, region_id, ssh_key_id=None):
	"""name Required, String, this is the name of the droplet - must be formatted by hostname rules
		size_id Required, Numeric, this is the id of the size you would like the droplet created at
		image_id Required, Numeric, this is the id of the image you would like the droplet created with
		region_id Required, Numeric, this is the id of the region you would like your server in
		ssh_key_ids Optional, Numeric CSV, comma separated list of ssh_key_ids that you would like to be added to the server"""

	url = BASEURL + 'droplets/new'
	payload = AUTH
	payload['name']=name
	payload['size_id']=size_id
	payload['image_id']=image_id
	payload['region_id']=region_id
	if ssh_key_id!=None:
		payload['ssh_key_id']=ssh_key_id
	req = requests.get(url, params=payload)
	return req.json()

#may have to make all droplet based tasks same function?
def destroy(DROPLET_ID):
	"""droplet_id Required, Numeric, this is the id of the droplet you would like to destroy"""
	url = BASEURL + 'droplets/' + str(DROPLET_ID) + '/destroy/'
	payload = AUTH
	req = requests.get(url, params=payload)
	return req.json()

def getimages(filter=None):
	"""filter Optional, String, may be "global", "my_images", or None (the default)"""
	url = BASEURL + 'images/'
	payload = AUTH
	if filter=='global' or filter=="my_images":
		payload['filter']=filter
	req = requests.get(url, params=payload)
	return req.json()

def main():
	args=sys.argv
	commands=['getdrops','getimages','getkeys',\
	'getregions','getsizes','showkey','start',\
	'status','stop','kill','create','destroy']

	if [x for x in commands if x in args[1:]]:
		print args[1:]
		#cmd=args[1]
		#args=args[2:]
		#exec(cmd, globals())
	else:
		print "Usage: " + args[0] + """ {getdrops|getimages [global]|getkeys|getregions|getsizes}
		{create} DROPLET_NAME IMAGE_ID SSH_KEY_ID SIZE_ID REGION_ID
		{showkey} SSH_KEY_ID
		{status|start|stop|kill|destroy} DROPLET_ID

		a CLIENT_ID and API_KEY are required a sample file will be created
		a DROPLET_ID is required for any action affecting a specific host"""
	pass

if __name__ == '__main__':
	main()


#donut.create(size='512MB', name='mynewhost', ssh='sshkeyname')