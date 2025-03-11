#!/bin/bash

# Ensure that the file path is provided as an argument
if [ -z "$1" ]; then
  echo "Please provide the path to the file."
  exit 1
fi

# Upload the file to tmpfiles.org and capture the response
response=$(curl -s -F "file=@$1" https://tmpfiles.org/api/v1/upload)

# Use jq to extract and echo only the URL from the JSON response
echo "$response" | jq -r '.data.url'
