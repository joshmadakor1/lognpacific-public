# Define the log file path
$logFile = "C:\ProgramData\entropygorilla.log"
$scriptName = "portscan.ps1"

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

# Define the range of IP addresses to scan
$startIP = 5
$endIP = 10
$baseIP = "10.0.0."

# Expanded list of common ports (well-known port numbers 0-1023 + some higher)
$commonPorts = @(21, 22, 23, 25, 53, 69, 80, 110, 123, 135, 137, 138, 139, 143, 161, 194, 443, 445, 465, 587, 993, 995, 3306, 3389, 5900, 8080, 8443)

# Log the start of the scan
Log-Message "Starting port scan on IP range $baseIP$startIP to $baseIP$endIP."

# Function to test a single IP and all its common ports
function Test-Ports {
    param (
        [string]$ip,
        [array]$ports,
        [string]$logFile
    )

    # Log that port scanning has started for the IP
    Log-Message "Scanning ports on $ip."

    # Test each port on the given IP
    foreach ($port in $ports) {
        try {
            $result = Test-NetConnection -ComputerName $ip -Port $port -WarningAction SilentlyContinue
            if ($result.TcpTestSucceeded) {
                $message = "Port $port is open on $ip."
                Write-Host $message
                Log-Message $message
            } else {
                $message = "Port $port is closed on $ip."
                Write-Host $message
                Log-Message $message
            }
        } catch {
            $errorMessage = "Error testing port $port on $($ip): $($_)"
            Write-Host $errorMessage
            Log-Message $errorMessage "ERROR"
        }
    }

    # Log that port scanning has finished for the IP
    Log-Message "Finished scanning ports on $ip."
}

# Loop through each IP in the range
for ($i = $startIP; $i -le $endIP; $i++) {
    $ip = $baseIP + $i

    try {
        # Test connectivity using Test-NetConnection (ICMP ping)
        $ping = Test-NetConnection -ComputerName $ip -WarningAction SilentlyContinue

        if ($ping.PingSucceeded) {
            $message = "$ip is online."
            Write-Host $message
            Log-Message $message

            # Scan all ports on the online host sequentially (no threads)
            Test-Ports -ip $ip -ports $commonPorts -logFile $logFile
        } else {
            $message = "$ip is offline."
            Write-Host $message
            Log-Message $message
        }
    } catch {
        $errorMessage = "Error testing $($ip): $($_)"
        Write-Host $errorMessage
        Log-Message $errorMessage "ERROR"
    }
}

# Log the end of the scan
Log-Message "Port scan completed."
