 # Define the path to the uninstall helper
$installerPath = 'C:\Users\labuser\Downloads\Firefox Setup 110.0b5.exe'

# Check if the uninstall helper exists
if (Test-Path $installerPath) {
    # If the file exists, execute it silently
    Invoke-Expression "& `"$installerPath`" /S"
    Write-Host "Firefox install command executed."
} else {
    Write-Host "Firefox installer does not exist at the specified path."
}
 
