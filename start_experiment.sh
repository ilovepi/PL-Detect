#!/bin/sh

# EXPERIMENT the name of the experimental script or command to execute (don't forget leading './' if necessary)
EXPERIMENT=

EXPERIMENT_FOLDER_NAME=

# the name of the slice to log into planetlab nodes
SLICE_NAME=

ssh -T ${SLICE_NAME}@$1 "cd $EXPERIMENT_FOLDER_NAME; $EXPERIMENT"
