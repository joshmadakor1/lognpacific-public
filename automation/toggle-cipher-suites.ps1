<#
.SYNOPSIS
    Toggles ciphersuites (secure vs insecure) on the system.
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

.USAGE
    Set [$secureEnvironment = $true] to secure the system
    Example syntax:
    PS C:\> .\toggle-cipher-suites.ps1 
#>


# Set this variable to $true for a secure environment, $false for an insecure environment
$secureEnvironment = $true

# Define the secure cipher suite list as a comma-separated string
$secureCipherSuites = "TLS_AES_256_GCM_SHA384,TLS_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_DHE_RSA_WITH_AES_256_GCM_SHA384,TLS_DHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA,TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_128_GCM_SHA256,TLS_RSA_WITH_AES_256_CBC_SHA256,TLS_RSA_WITH_AES_128_CBC_SHA256,TLS_RSA_WITH_AES_256_CBC_SHA,TLS_RSA_WITH_AES_128_CBC_SHA,TLS_RSA_WITH_NULL_SHA256,TLS_RSA_WITH_NULL_SHA,TLS_PSK_WITH_AES_256_GCM_SHA384,TLS_PSK_WITH_AES_128_GCM_SHA256,TLS_PSK_WITH_AES_256_CBC_SHA384,TLS_PSK_WITH_AES_128_CBC_SHA256,TLS_PSK_WITH_NULL_SHA384,TLS_PSK_WITH_NULL_SHA256"

# Define the insecure cipher suite list, which includes all secure ciphers plus additional insecure ones
$insecureCipherSuites = "TLS_AES_256_GCM_SHA384,TLS_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_DHE_RSA_WITH_AES_256_GCM_SHA384,TLS_DHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA,TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_128_GCM_SHA256,TLS_RSA_WITH_AES_256_CBC_SHA256,TLS_RSA_WITH_AES_128_CBC_SHA256,TLS_RSA_WITH_AES_256_CBC_SHA,TLS_RSA_WITH_AES_128_CBC_SHA,TLS_RSA_WITH_NULL_SHA256,TLS_RSA_WITH_NULL_SHA,TLS_PSK_WITH_AES_256_GCM_SHA384,TLS_PSK_WITH_AES_128_GCM_SHA256,TLS_PSK_WITH_AES_256_CBC_SHA384,TLS_PSK_WITH_AES_128_CBC_SHA256,TLS_PSK_WITH_NULL_SHA384,TLS_PSK_WITH_NULL_SHA256,TLS_RSA_WITH_DES_CBC_SHA,TLS_RSA_WITH_3DES_EDE_CBC_SHA,TLS_RSA_WITH_RC4_128_SHA,TLS_RSA_WITH_RC4_128_MD5,TLS_RSA_EXPORT1024_WITH_DES_CBC_SHA,TLS_RSA_EXPORT1024_WITH_RC4_56_SHA,TLS_RSA_EXPORT_WITH_RC2_CBC_40_MD5,TLS_RSA_EXPORT_WITH_RC4_40_MD5,SSL_RSA_WITH_DES_CBC_SHA,SSL_RSA_WITH_3DES_EDE_CBC_SHA,SSL_RSA_WITH_RC4_128_SHA,SSL_RSA_WITH_RC4_128_MD5,SSL_RSA_EXPORT1024_WITH_DES_CBC_SHA,SSL_RSA_EXPORT1024_WITH_RC4_56_SHA,SSL_RSA_EXPORT_WITH_RC2_CBC_40_MD5,SSL_RSA_EXPORT_WITH_RC4_40_MD5"

# Define the registry path where the cipher suite order is stored
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002"

# Check if the registry key exists, if not, create it
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force
}

# Determine the cipher suites list based on the secureEnvironment variable
if ($secureEnvironment) {
    $selectedCipherSuites = $secureCipherSuites
    Write-Output "Configuring a secure environment..."
} else {
    $selectedCipherSuites = $insecureCipherSuites
    Write-Output "Configuring an insecure environment..."
}

# Set the cipher suite order in the registry
Set-ItemProperty -Path $regPath -Name "Functions" -Value $selectedCipherSuites

# Enable SSL Cipher Suite Order in Group Policy
$policyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL"
$policyKey = "00010002"
$policyName = "Functions"

if (-not (Test-Path "$policyPath\$policyKey")) {
    New-Item -Path "$policyPath" -Name "$policyKey" -Force
}

# Apply the selected cipher suites to the Group Policy
Set-ItemProperty -Path "$policyPath\$policyKey" -Name $policyName -Value $selectedCipherSuites

# Verify the changes
Write-Output "Cipher Suites have been updated to:"
Get-ItemProperty -Path $regPath -Name "Functions" | Select-Object -ExpandProperty Functions

# Enable SSL Cipher Suite Order policy
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002" -Name "Enabled" -Value 1

# Inform the user to restart the server for changes to take effect
Write-Output "Please restart the server to apply the changes."

# End of combined script
 
