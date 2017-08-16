#!/bin/bash
# This script takes lines from a tab separated file,
# and uses them to compose an 'at' command
# the first field in the file is expected to be a time,
# in a format compatible with 'at' (see docs)
# the Second field is an IP address used to  determine target hosts
# eventually it should become part of the command,
# the Third field is the command to be scheduled.


# Timeout: maximum running time for an experiment in seconds
TIMEOUT=115

IFS=$'\t'
while read line
do
    arr=(${line})
    at ${arr[0]} << ENDMARKER
    ${arr[2]} ${arr[1]}
ENDMARKER
done < $1
