#!/bin/sh
# File Containing Target IP Address
IP_FILE=$1
# path to local experiment direcory to rsync
EXPERIMENT_DIRECTORY=

SLICE_NAME=
# path to home directory on planet lab: eg. /home/slice_name
SLICE_HOME=/home/$SLICE_NAME


# Packages to install on remote machine
PACKAGES="MySQL-python python mysql python-json python-simplejson"

# SSH into the planet lab node install required packages
parallel-ssh -t 120 -h ${IP_FILE} -vl $SLICE_NAME "sudo yum --nogpgcheck install -y ${PACKAGES}"

parallel-ssh -h ${IP_FILE} -vl $SLICE_NAME "rm -rf remote_host"

# Rsync the experimental directory on the Planet lab node
parallel-rsync -h ${IP_FILE} -X "--copy-links" -rl $SLICE_NAME ${EXPERIMENT_DIRECTORY} ${SLICE_HOME}/

