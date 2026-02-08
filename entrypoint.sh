#!/bin/bash

# Cloud Run defines the PORT environment variable
PORT=${PORT:-8080}

# Create user mrxtopia with password mrxtopia
USER_NAME="mrxtopia"
USER_PASS="mrxtopia"

# Check if user already exists
if ! id "$USER_NAME" &>/dev/null; then
    useradd -m -s /bin/bash "$USER_NAME"
    echo "$USER_NAME:$USER_PASS" | chpasswd
    usermod -aG sudo "$USER_NAME"
    echo "User $USER_NAME created."
fi

# Generate host keys if not present (for sshd if needed locally)
ssh-keygen -A

# Start ttyd to provide a web terminal
# It will run the 'login' command to prompt for username/password
echo "Starting Web Terminal on port $PORT..."
exec /usr/local/bin/ttyd -p $PORT login
