#!/bin/bash

RESOURCE_GROUP=$1
STORAGE_ACCOUNT=$2
CONTAINER_NAME=private

# Get the key from the storage account using the current logged on user
ACCESS_KEY=`azure storage account keys list $STORAGE_ACCOUNT -g $RESOURCE_GROUP --json | jq -r '.storageAccountKeys.key1'`

# Upload the blobs
azure storage blob upload -q -a $STORAGE_ACCOUNT -k $ACCESS_KEY azuredeploy.json $CONTAINER_NAME custom-private-template/azuredeploy.json
azure storage blob upload -q -a $STORAGE_ACCOUNT -k $ACCESS_KEY web_server.json $CONTAINER_NAME custom-private-template/web_server.json
azure storage blob upload -q -a $STORAGE_ACCOUNT -k $ACCESS_KEY install_nodejs.sh $CONTAINER_NAME custom-private-template/install_nodejs.sh
