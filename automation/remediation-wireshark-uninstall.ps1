<#
.SYNOPSIS
    Uninstalls Wireshark from the system executing the script.
    Tested on Wireshark Version 2.2.1 (v2.2.1-0-ga6fbd27 from master-2.2).
    Please test thoroughly in a non-production environment before deploying widely.
    Make sure to run as Administrator or with appropriate privileges.

.NOTES
    Author        : Josh Madakor
    Date Created  : 2024-09-09
    Last Modified : 2024-09-09
    Version       : 1.0

.TESTED ON
    Date(s) Tested  : 2024-09-09
    Tested By       : Josh Madakor
    Systems Tested  : Windows Server 2019 Datacenter, Build 1809
    PowerShell Ver. : 5.1.17763.6189
    Wireshark Ver.  : 2.2.1 (v2.2.1-0-ga6fbd27 from master-2.2)

.USAGE
    Example syntax:
    PS C:\> .\remediation-wireshark-uninstall.ps1 
#>
 
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
 
