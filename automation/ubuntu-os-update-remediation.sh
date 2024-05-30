#!/bin/bash

# Display the current OpenSSL version
echo "Current OpenSSL version:"
openssl version

# Update package repository
sudo apt update

# Upgrade all packages
sudo apt full-upgrade -y

# Recheck OpenSSL version to confirm if it has been upgraded
echo "Updated OpenSSL version:"
openssl version

# System reboot to apply all updates
echo "Rebooting system to apply all updates..."
sudo reboot
