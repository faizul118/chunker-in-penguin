#!/usr/bin/env python3
import requests
import subprocess
import time

# Configuration: update these with your bot's token and your Telegram user ID.
BOT_TOKEN = "7851874160:AAFqHDKUpk3fv1Db-k0JDh1mf41-6OGlXoc"
AUTHORIZED_USER_ID = "1287200792"  # e.g., "123456789"
TELEGRAM_API_URL = f"https://api.telegram.org/bot{BOT_TOKEN}"

def get_updates(offset=None):
    url = f"{TELEGRAM_API_URL}/getUpdates"
    params = {}
    if offset is not None:
        params["offset"] = offset
    response = requests.get(url, params=params)
    return response.json()

def send_message(chat_id, text):
    url = f"{TELEGRAM_API_URL}/sendMessage"
    # Wrap text in <pre> tags to display it in a monospace font.
    data = {
        "chat_id": chat_id,
        "text": f"<code>{text}</code>",
        "parse_mode": "HTML"
    }
    response = requests.post(url, data=data)
    return response.json()

def execute_command(command):
    try:
        output = subprocess.check_output(
            command,
            shell=True,
            stderr=subprocess.STDOUT,
            timeout=30,
            universal_newlines=True
        )
    except subprocess.CalledProcessError as e:
        output = e.output
    except Exception as e:
        output = f"Error: {e}"
    if not output.strip():
        output = "Command executed successfully with no output."
    return output

def main():
    last_update_id = None
    print("Bot is polling for updates...")

    while True:
        updates = get_updates(last_update_id)
        if "result" in updates:
            for update in updates["result"]:
                last_update_id = update["update_id"] + 1

                if "message" not in update:
                    continue

                message = update["message"]
                chat_id = str(message["chat"]["id"])

                # Only process messages from the authorized user.
                if chat_id != AUTHORIZED_USER_ID:
                    continue

                if "text" not in message:
                    continue

                command = message["text"]
                print(f"Received command: {command}")

                output = execute_command(command)

                # Send each non-empty line as a separate monospace message.
                for line in output.splitlines():
                    if line.strip():
                        send_message(chat_id, line)

                print("Response sent.")

        # Poll every 0.5 seconds.
        time.sleep(0.5)

if __name__ == "__main__":
    main()
