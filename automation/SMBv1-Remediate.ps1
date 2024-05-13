 # Run PowerShell as Administrator

# Disable SMBv1 - CIFS File Sharing Support
Write-Output "Disabling SMBv1 Protocol..."
Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart

# Disable the SMBv1 Client
$clientKeyPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters"
$clientDriverPath = "HKLM:\SYSTEM\CurrentControlSet\Services\mrxsmb10"
Write-Output "Disabling SMBv1 Client..."
if (Test-Path $clientKeyPath) {
    Set-ItemProperty -Path $clientKeyPath -Name "AllowInsecureGuestAuth" -Value 0
}
if (Test-Path $clientDriverPath) {
    Set-ItemProperty -Path $clientDriverPath -Name "Start" -Value 4
} else {
    Write-Output "SMBv1 Client driver registry path does not exist. It may not be necessary or supported on this system."
}

# Disable the SMBv1 Server
$serverKeyPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"
Write-Output "Disabling SMBv1 Server..."
if (Test-Path $serverKeyPath) {
    Set-ItemProperty -Path $serverKeyPath -Name "SMB1" -Value 0
} else {
    Write-Output "SMBv1 Server registry path does not exist. Check if SMBv1 is supported on this system."
}

Write-Output "SMBv1 has been disabled on your system. Please review the output for any potential issues."
 
