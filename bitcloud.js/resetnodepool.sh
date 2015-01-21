#!/bin/sh


if [ $# -eq 0 ]; then
    echo "This utility resets or creates the nodepool."
    echo "Name of the nodepool required as first parameter."
    exit 1
fi

rm -f $1
cat nodepool.sql | sqlite3 $1
echo $1 reset
