 # Define the variables
$wiresharkDisplayName = "Wireshark 2.2.1 (64-bit)"
$uninstallerPath = "$env:ProgramFiles\Wireshark\uninstall.exe"
$silentUninstallSwitch = "/S"

# Function to check if Wireshark is installed
function Is-WiresharkInstalled {
    return Test-Path -Path $uninstallerPath
}

# Function to uninstall Wireshark
function Uninstall-Wireshark {
    if (Is-WiresharkInstalled) {
        Write-Output "Uninstalling Wireshark..."
        & $uninstallerPath $silentUninstallSwitch
        Write-Output "$($wiresharkDisplayName) has been uninstalled."
    } else {
        Write-Output "$($wiresharkDisplayName) is not installed."
    }
}

# Execute the uninstall function
Uninstall-Wireshark
 
