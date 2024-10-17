 # Define the log file path
$logFile = "C:\ProgramData\entropygorilla.log"
$scriptName = "eicar.ps1"

# Function to log messages
function Log-Message {
    param (
        [string]$message,
        [string]$level = "INFO"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp [$level] [$scriptName] $message"
    Add-Content -Path $logFile -Value $logEntry
}

# EICAR Test String
$eicarTestString1 = 'X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR'
$eicarTestString2 = '-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*'

# Define the file path where EICAR file will be created
$eicarFilePath = "C:\ProgramData\EICAR.txt"

# Start logging
Log-Message "Starting creation of EICAR test file."

try {
    # Check if the file already exists, and if it does, delete it first
    if (Test-Path -Path $eicarFilePath) {
        Remove-Item -Path $eicarFilePath -Force
        Log-Message "Existing EICAR file found and deleted."
    }

    # Create the EICAR test file
    "$($eicarTestString1)$($eicarTestString2)" | Out-File -FilePath $eicarFilePath -Force
    Log-Message "EICAR test file created at $eicarFilePath."

} catch {
    $errorMessage = "An error occurred while creating the EICAR file: $_"
    Write-Host $errorMessage
    Log-Message $errorMessage "ERROR"
}

# End logging
Log-Message "EICAR test file creation completed."
 
