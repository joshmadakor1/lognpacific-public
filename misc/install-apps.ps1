 # Download Steghide
 Invoke-WebRequest -Uri 'https://sacyberrange00.blob.core.windows.net/vm-applications/steghide-0.5.1-win32.zip' -OutFile 'C:\programdata\steghide-0.5.1-win32.zip'

 # Download 7zip
 Invoke-WebRequest -Uri 'https://sacyberrange00.blob.core.windows.net/vm-applications/7z2408-x64.exe' -OutFile 'C:\programdata\7z2408-x64.exe'
 
 # Install 7zip silently
 Start-Process 'C:\programdata\7z2408-x64.exe' -ArgumentList '/S' -Wait
 
 # Extract Steghide
 Expand-Archive -Path 'C:\programdata\steghide-0.5.1-win32.zip' -DestinationPath 'C:\programdata' -Force
