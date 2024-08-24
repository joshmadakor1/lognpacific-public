#!/bin/bash

# Stop the inetd service
sudo systemctl stop inetd.service

# Disable the inetd service to prevent it from starting at boot
sudo systemctl disable inetd.service

# Remove the telnetd package completely, including its configuration files
sudo apt remove --purge telnetd -y

# Remove the inetutils-inetd package completely, including its configuration files
sudo apt remove --purge inetutils-inetd -y

# Remove any unused dependencies that were installed with telnetd or inetutils-inetd
sudo apt autoremove -y

# Update the package lists to ensure they are current
sudo apt update

# Download the script
# wget https://raw.githubusercontent.com/joshmadakor1/lognpacific-public/main/automation/remediation-Telnet-Remove.sh --no-check-certificate

# Make the script executable:
# chmod +x remediation-Telnet-Remove.sh

# Execute the script:
# ./remediation-Telnet-Remove.sh
