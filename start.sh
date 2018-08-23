#!/bin/bash

# Start a new droplet to be used as a socks5 proxy machine

# Prerequisites
# 1- generate API token and login with the generated token
# 2- install "doctl" locally

# Token String
# Uncomment the following line to use this script with API Token

# ssh private key path
SSH_KEY_NAME="socks5"
SSH_KEY_PATH=~/.ssh/${SSH_KEY_NAME}_key

# Machine sizes can be optained by running this command in terminal.
# $ doctl compute size list
size="s-1vcpu-1gb"

# Configure image type or use a snapshot
# Available images can be optained by running this command in terminal.
# $ doctl compute image list --public
image="ubuntu-16-04-x64"

# Configure Region
# Available regions can be optained by running this command in terminal.
# $ doctl compute region list
region="nyc1"

# Image name
droplet_name="socks5-machine"

# Create new ssh key and add the key to user account
# echo "Creating new ssh key"
#
ssh-keygen -t rsa -b 4096 -f $SSH_KEY_PATH -q -N ""  # create new ssh key
SSH_KEY_DATA="$(doctl compute ssh-key create $SSH_KEY_NAME --public-key "$(cat $SSH_KEY_PATH.pub)" \
--format Name,FingerPrint | grep $SSH_KEY_NAME)"
echo "${SSH_KEY_DATA}"
SSH_key_FingerPrint=${SSH_KEY_DATA#$SSH_KEY_NAME    } # created ssh key fingerprint

# Start the droplet

echo "Starting new droplet"

doctl compute droplet create $droplet_name --size $size --image $image \
--region $region --ssh-keys $SSH_key_FingerPrint --wait


droplet_data="$(doctl compute droplet list --format Name,PublicIPv4 | grep $droplet_name)"
echo "${droplet_data}"

droplet_ip=${droplet_data#$droplet_name    } # droplet public ip

###########################################################################################
###########################################################################################
###########################################################################################

# Socks5 proxy configuration

echo "Socks5 Connect"

PORT=8123

echo "ssh -i $SSH_KEY_PATH -D $PORT -q -f -C -N -y root@$droplet_ip"
ssh -i $SSH_KEY_PATH -D $PORT -q -f -C -N root@$droplet_ip

ps aux | grep ssh
