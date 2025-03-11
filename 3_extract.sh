#!/bin/bash

# Extract the ZIP file
mkdir -p "input"
unzip -q -o "$1.zip" -d "input"

# Remove the ZIP file after extraction
# rm "$1.zip"