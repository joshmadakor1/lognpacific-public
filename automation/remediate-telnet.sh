#!/bin/bash

# Update your package list
sudo apt update

# Stop the xinetd service to ensure changes can be made safely
sudo systemctl stop xinetd

# Remove telnet server packages
sudo apt remove --purge -y xinetd telnetd

# Remove the telnet configuration file if it exists
if [ -f /etc/xinetd.d/telnet ]; then
    sudo rm /etc/xinetd.d/telnet
fi

# Restart xinetd to apply changes, if still installed
if systemctl is-enabled --quiet xinetd; then
    sudo systemctl restart xinetd
else
    echo "xinetd is not installed."
fi

# Optional: disable xinetd if you do not need it for other services
# sudo systemctl disable xinetd

echo "Telnet and related configurations have been removed."
