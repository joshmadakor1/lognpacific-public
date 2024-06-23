 # PowerShell Script to Toggle the "Guest" Account on Windows Server 2019

# Step 1: Define the desired action for the Guest account
# Set this variable to $true to enable the Guest account or $false to disable it
$enableGuestAccount = $true  # Change to $false to disable the account

# Step 2: Define the username for the Guest account
$guestAccount = "Guest"

# Step 3: Check the current status of the Guest account
# Using net user command to check if the Guest account is enabled or disabled
$guestStatus = net user $guestAccount

# Function to enable or disable the Guest account based on the desired action
function Toggle-GuestAccount {
    param (
        [string]$accountName,
        [bool]$enableAccount
    )
    
    if ($enableAccount) {
        # Enable the Guest account if it is currently disabled
        if ($guestStatus -like "*Account active*No*") {
            net user $accountName /active:yes
            Write-Host "The Guest account has been successfully enabled."
        } else {
            Write-Host "The Guest account is already enabled."
        }
    } else {
        # Disable the Guest account if it is currently enabled
        if ($guestStatus -like "*Account active*Yes*") {
            net user $accountName /active:no
            Write-Host "The Guest account has been successfully disabled."
        } else {
            Write-Host "The Guest account is already disabled."
        }
    }
}

# Step 4: Call the function to toggle the Guest account status
Toggle-GuestAccount -accountName $guestAccount -enableAccount $enableGuestAccount
