#!/bin/bash

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

# Generate host keys if not present
ssh-keygen -A

# Start SSH server in foreground
echo "Starting SSH server..."
exec /usr/sbin/sshd -D -e
