# Define paths for Steghide and 7-Zip executables
$steghidePath = 'C:\ProgramData\steghide\steghide.exe'
$sevenZipPath = 'C:\Program Files\7-Zip\7z.exe'

# Check if Steghide is already installed
if (-Not (Test-Path $steghidePath)) {
    # Download Steghide
    Invoke-WebRequest -Uri 'https://sacyberrange00.blob.core.windows.net/vm-applications/steghide-0.5.1-win32.zip' -OutFile 'C:\programdata\steghide-0.5.1-win32.zip'
    
    # Extract Steghide
    Expand-Archive -Path 'C:\programdata\steghide-0.5.1-win32.zip' -DestinationPath 'C:\programdata' -Force

    Write-Host "Steghide downloaded and extracted."
} else {
    Write-Host "Steghide is already installed."
}

# Check if 7-Zip is already installed
if (-Not (Test-Path $sevenZipPath)) {
    # Download 7-Zip
    Invoke-WebRequest -Uri 'https://sacyberrange00.blob.core.windows.net/vm-applications/7z2408-x64.exe' -OutFile 'C:\programdata\7z2408-x64.exe'

    # Install 7-Zip silently
    Start-Process 'C:\programdata\7z2408-x64.exe' -ArgumentList '/S' -Wait

    Write-Host "7-Zip downloaded and installed."
} else {
    Write-Host "7-Zip is already installed."
}
 
