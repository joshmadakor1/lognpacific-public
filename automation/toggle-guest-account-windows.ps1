# PowerShell Script to Toggle the "Guest" Account on Windows Server 2019
$enableGuestAccount = $true  # Set to $true to enable, $false to disable

# Step 1: Define the username for the Guest account and desired state
$guestAccount = "Guest"

# Step 2: Get the Guest account object
# Using Get-LocalUser cmdlet to retrieve the account information
$guestUser = Get-LocalUser -Name $guestAccount

# Check if the Guest account exists
if ($guestUser) {
    # Step 3: Toggle the Guest account based on the desired state
    if ($guestUser.Enabled -ne $enableGuestAccount) {
        Set-LocalUser -Name $guestAccount -Enabled $enableGuestAccount

        # Step 4: Provide feedback to the user based on the action taken
        if ($enableGuestAccount) {
            Write-Host "The Guest account has been successfully enabled."
        } else {
            Write-Host "The Guest account has been successfully disabled."
        }
    } else {
        # If the account is already in the desired state, provide appropriate feedback
        if ($enableGuestAccount) {
            Write-Host "The Guest account is already enabled."
        } else {
            Write-Host "The Guest account is already disabled."
        }
    }
} else {
    Write-Host "The Guest account does not exist on this system."
}

# End of Script
