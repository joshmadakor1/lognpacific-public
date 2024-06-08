#!/bin/bash
echo -e "Cyberlab123!\nCyberlab123!" | sudo passwd root

# This will delete the file after you're done so it doesn't store the password on the local system
# There are better ways to go about this, but this is just a proof of concept to remediate this particular vulnerability.
rm remediation-root-password.sh

# Make the script executable:
# chmod +x remediation-root-password.sh

# Execute the script:
# ./remediation-root-password.sh
