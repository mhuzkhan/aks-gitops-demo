#!/bin/bash

# Bootstrap script for Azure Storage backend
# Usage: ./bootstrap-backend.sh <resource-group> <storage-account> <container> <location>

set -e

RG=$1
SA=$2
CN=$3
LOCATION=$4

if [ -z "$RG" ] || [ -z "$SA" ] || [ -z "$CN" ] || [ -z "$LOCATION" ]; then
    echo "Usage: $0 <resource-group> <storage-account> <container> <location>"
    exit 1
fi

echo "Creating resource group: $RG"
az group create --name "$RG" --location "$LOCATION"

echo "Creating storage account: $SA"
az storage account create \
    --resource-group "$RG" \
    --name "$SA" \
    --location "$LOCATION" \
    --sku Standard_LRS \
    --encryption-services blob

echo "Creating storage container: $CN"
az storage container create \
    --name "$CN" \
    --account-name "$SA"

echo "Backend configuration:"
echo "  resource_group_name = \"$RG\""
echo "  storage_account_name = \"$SA\""
echo "  container_name = \"$CN\""
echo "  key = \"prod.tfstate\""
