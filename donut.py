import os
import requests

YOUR_CLIENT_ID=os.getenv('YOUR_CLIENT_ID')
YOUR_API_KEY=os.getenv('YOUR_API_KEY')

GETDROPS="""https://api.digitalocean.com/droplets/?client_id=[YOUR_CLIENT_ID]&api_key=[YOUR_API_KEY]"""
GETSTATUS="""https://api.digitalocean.com/droplets/[DROPLET_ID]?client_id=[YOUR_CLIENT_ID]&api_key=[YOUR_API_KEY]"""

URL='https://api.digitalocean.com/droplets/'

def getdrops():
	"""returns a json object containing all droplets"""
	payload={'client_id':YOUR_CLIENT_ID, 'api_key':YOUR_API_KEY}
	req = requests.get(URL, params=payload)
	return req

def status(id, size, crap):
	pass

def create(id, size, region, ssh):
	pass
