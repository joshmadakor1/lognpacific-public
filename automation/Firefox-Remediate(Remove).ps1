 # Define the path to the uninstall helper
$uninstallHelperPath = 'C:\Program Files\Mozilla Firefox\uninstall\helper.exe'

# Check if the uninstall helper exists
if (Test-Path $uninstallHelperPath) {
    # If the file exists, execute it silently
    Invoke-Expression "& `"$uninstallHelperPath`" /S"
    Write-Host "Firefox uninstall command executed."
} else {
    Write-Host "Firefox uninstall helper does not exist at the specified path."
}
 
