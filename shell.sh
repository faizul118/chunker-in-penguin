#!/bin/bash

# Your Telegram Bot Token
BOT_TOKEN="7851874160:AAFqHDKUpk3fv1Db-k0JDh1mf41-6OGlXoc"

# Your Telegram User ID (replace with your actual user id)
USER_ID="YOUR_TELEGRAM_USER_ID"

# Store the last processed update ID
LAST_UPDATE_ID=0

while true; do
    # Fetch updates from Telegram
    RESPONSE=$(curl -s "https://api.telegram.org/bot$BOT_TOKEN/getUpdates?offset=$((LAST_UPDATE_ID+1))")
    
    # Debug: Uncomment to print raw response
    # echo "Raw response: $RESPONSE"
    
    # Check if the response is valid JSON
    if ! echo "$RESPONSE" | jq empty 2>/dev/null; then
        echo "Received invalid JSON: $RESPONSE"
        sleep 2
        continue
    fi

    # Parse updates array; if there are no updates, this will be empty.
    UPDATES=$(echo "$RESPONSE" | jq -c '.result[]' 2>/dev/null)

    for UPDATE in $UPDATES; do
        # Extract update ID, chat id, and message text
        UPDATE_ID=$(echo "$UPDATE" | jq '.update_id')
        CHAT_ID=$(echo "$UPDATE" | jq -r '.message.chat.id')
        MESSAGE=$(echo "$UPDATE" | jq -r '.message.text')

        # Process only if message is from authorized user
        if [ "$CHAT_ID" == "$USER_ID" ]; then
            OUTPUT=$(bash -c "$MESSAGE" 2>&1)
            RESPONSE_TEXT="Command: $MESSAGE\n\nOutput:\n$OUTPUT"

            curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
                -d "chat_id=$CHAT_ID" \
                -d "text=$RESPONSE_TEXT"
        fi

        # Update the last processed update ID
        LAST_UPDATE_ID=$UPDATE_ID
    done

    sleep 2
done
