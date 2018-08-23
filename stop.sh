#!/bin/bash

# Stop the running service first


# delete the droplet
droplet_name="socks5-machine"
doctl compute droplet delete -f $droplet_name

# Remove ssh keys
SSH_KEY_NAME="socks5"
SSH_KEY_PATH=~/.ssh/${SSH_KEY_NAME}_key

echo "Removing ssh key"

SSH_KEY_DATA="$(doctl compute ssh-key list --format Name,FingerPrint | grep $SSH_KEY_NAME)"
echo "${SSH_KEY_DATA}"
SSH_key_FingerPrint=${SSH_KEY_DATA#$SSH_KEY_NAME    } # ssh key fingerprint

doctl compute ssh-key delete $SSH_key_FingerPrint -f

rm $SSH_KEY_PATH*
