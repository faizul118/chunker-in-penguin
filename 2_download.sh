#!/bin/bash

FILEURL="$1"
FILENAME="$2"


# Download the file using curl
curl -L "$FILEURL" -o "$FILENAME.zip"