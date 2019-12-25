#!/bin/bash

# install ssh key

SSH_DIR="/home/ubuntu/.ssh"

env

mkdir $SSH_DIR
chmod 700 $SSH_DIR
# Comes from env var in packer
echo $UBUNTU_SSH_KEY >> $SSH_DIR/authorized_keys
chmod 600 $SSH_DIR/authorized_keys
chown -R ubuntu:ubuntu $SSH_DIR