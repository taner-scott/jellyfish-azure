#!/bin/bash

RESOURCE_GROUP=$1
STORAGE_ACCOUNT=$2

# Get the key from the storage account using the current logged on user
ACCESS_KEY=`azure storage account keys list $STORAGE_ACCOUNT -g $RESOURCE_GROUP --json | q -r '.storageAccountKeys.key1'`

# Setup the private container
azure storage container create private -a $STORAGE_ACCOUNT -k $ACCESS_KEY

# Setup the public container
azure storage container create public -p Container -a $STORAGE_ACCOUNT -k $ACCESS_KEY
