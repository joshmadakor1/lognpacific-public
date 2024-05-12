# Run PowerShell as Administrator

# Check if SSL 3.0 is already available
$ssl3ClientPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Client"
$ssl3ServerPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server"

# Create registry path if it does not exist for Client and Server
if (-not (Test-Path $ssl3ClientPath)) {
    New-Item -Path $ssl3ClientPath -Force
}
if (-not (Test-Path $ssl3ServerPath)) {
    New-Item -Path $ssl3ServerPath -Force
}

# Enable SSL 3.0 for Client
New-ItemProperty -Path $ssl3ClientPath -Name "Enabled" -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path $ssl3ClientPath -Name "DisabledByDefault" -Value 0 -PropertyType DWORD -Force

# Enable SSL 3.0 for Server
New-ItemProperty -Path $ssl3ServerPath -Name "Enabled" -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path $ssl3ServerPath -Name "DisabledByDefault" -Value 0 -PropertyType DWORD -Force

Write-Output "SSL 3.0 has been enabled. Your system is now vulnerable to POODLE."
