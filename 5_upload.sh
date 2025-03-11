#!/bin/bash

# Upload the file to tmpfiles.org and capture the response
response=$(curl -s -F "file=@$1" https://tmpfiles.org/api/v1/upload)

# Use jq to extract and echo only the URL from the JSON response
echo Uploaded successfully
echo "$response" | jq -r '.data.url'
