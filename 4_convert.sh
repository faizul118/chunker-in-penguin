#!/bin/bash

# Define the variables for CHUNKERINPUT and CHUNKEROUTPUT
CHUNKEROUTPUT="$1"
TARGETVERSION="$2"

# Run the chunker-cli command with the provided arguments
chmod +x ./chunker-cli/bin/chunker-cli
mkdir -p "output"
./chunker-cli/bin/chunker-cli -i "input" -o "output" -f "$TARGETVERSION"
rm -rf "chunker-cli"
rm -rf "input"

zip -r "$CHUNKEROUTPUT"_"$TARGETVERSION".zip "output"

echo Listing files...
ls -R output