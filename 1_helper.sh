#!/bin/bash

# Define the download URL
CHUNKERURL="https://github.com/HiveGamesOSS/Chunker/releases/latest/download/chunker-cli-linux-amd64.zip"

# Download the file
curl -L -o chunker.zip "$CHUNKERURL"

# Extract the ZIP file
unzip -q -o chunker.zip

# Remove the ZIP file after extraction
rm chunker.zip