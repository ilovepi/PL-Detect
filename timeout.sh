#!/bin/sh

timeout $@

if [ $? = 124 ]
then
    echo "Error The command '$@' timed out"
fi
