 # Run PowerShell as Administrator

# Disable SMBv1 - CIFS File Sharing Support
Write-Output "Disabling SMBv1 Protocol..."
Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart

# Disable the SMBv1 Client
Write-Output "Disabling SMBv1 Client..."
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" -Name "AllowInsecureGuestAuth" -Value 0
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\mrxsmb10" -Name "Start" -Value 4

# Disable the SMBv1 Server
Write-Output "Disabling SMBv1 Server..."
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "SMB1" -Value 0

Write-Output "SMBv1 has been disabled on your system."
 
