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
if [ -z "$3" ]; then
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
CHUNKERINPUT="input"         # Set CHUNKERINPUT as the name of the downloaded file (no extension)
CHUNKEROUTPUT="$FILENAME"        # Set CHUNKEROUTPUT the same way

TARGETVERSION="$2"        # Get target version from the second argument

# Run the chunker-cli command with the provided arguments
chmod +x ./chunker-cli/bin/chunker-cli
./chunker-cli/bin/chunker-cli -i "$CHUNKERINPUT" -o "$CHUNKEROUTPUT"_"$TARGETVERSION" -f "$TARGETVERSION"
rm -rf chunker-cli
echo "Download, extraction, and processing complete."

# Check if the CHUNKEROUTPUT folder exists before zipping
if [ -d "$CHUNKEROUTPUT"_"$TARGETVERSION" ]; then
    if [ ! -d "output" ]; then
        mkdir -p "output"
    fi
    # Create a zip of the contents inside the CHUNKEROUTPUT folder
    #zip -r "output/$CHUNKEROUTPUT"_"$TARGETVERSION.zip" "$CHUNKEROUTPUT"_"$TARGETVERSION"
    #rm -rf "$CHUNKEROUTPUT"_"$TARGETVERSION"
    rm -rf "input"
    echo "Zipping of output folder completed: $CHUNKEROUTPUT"_"$TARGETVERSION.zip"
    exit 0
else
    echo "Error: Output folder $CHUNKEROUTPUT"_"$TARGETVERSION does not exist. Unable to zip."
    exit 1
fi
