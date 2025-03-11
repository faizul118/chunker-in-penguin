#!/bin/bash

# Define the download URL
CHUNKERURL="https://github.com/HiveGamesOSS/Chunker/releases/latest/download/chunker-cli-linux-amd64.zip"

# Download the file
curl -L -o chunker.zip "$CHUNKERURL"

# Extract the ZIP file
unzip -q -o chunker.zip

# Remove the ZIP file after extraction
rm chunker.zip

# Define the download FILEURL (this will be the FILEURL of the Minecraft world or any other file)
FILEURL="$1"  # Assuming the first argument is the download FILEURL

# If $MCWORLDNAME is defined, use that as the filename for the download
if [ -n "$3" ]; then
    FILENAME="$3"
else
    # Extract the filename from the FILEURL and remove the extension
    # FILENAME=$(basename "$FILEURL" | sed 's/\.[^.]*$//')
    FILENAME=minecraft_world
fi

# Download the file using curl
curl -L -o "$FILENAME.zip" "$FILEURL"

# Extract the ZIP file
if [ ! -d "input" ]; then
    mkdir -p "input"
fi
unzip -q -o "$FILENAME.zip" -d "input"

# Remove the ZIP file after extraction
rm "$FILENAME.zip"

# Define the variables for CHUNKERINPUT and CHUNKEROUTPUT
CHUNKEROUTPUT="$FILENAME"        # Set CHUNKEROUTPUT the same way

TARGETVERSION="$2"        # Get target version from the second argument

# Run the chunker-cli command with the provided arguments
chmod +x ./chunker-cli/bin/chunker-cli
if [ ! -d "output" ]; then
    mkdir -p "output"
fi
./chunker-cli/bin/chunker-cli -i "input" -o "output" -f "$TARGETVERSION"
rm -rf chunker-cli
rm -rf "input"
echo "Download, extraction, and processing complete."

zip -r "$CHUNKEROUTPUT"_"$TARGETVERSION".zip "output"


ls -R output

zip_file_path="$CHUNKEROUTPUT"_"$TARGETVERSION".zip
./upload_curl.sh "$zip_file_path"
