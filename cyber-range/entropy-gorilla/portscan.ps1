 # Define the range of IP addresses to scan
$startIP = 5
$endIP = 25
$baseIP = "10.0.0."

# Expanded list of common ports (well-known port numbers 0-1023 + some higher)
$commonPorts = @(21, 22, 23, 25, 53, 69, 80, 110, 123, 135, 137, 138, 139, 143, 161, 194, 443, 445, 465, 587, 993, 995, 3306, 3389, 5900, 8080, 8443)

# Define the log file path (change the path if needed)
$logFile = "C:\programdata\scan_results.log"

# Function to test a single IP and all its common ports
function Test-Ports {
    param (
        [string]$ip,
        [array]$ports,
        [string]$logFile
    )

    # Test each port on the given IP
    foreach ($port in $ports) {
        $result = Test-NetConnection -ComputerName $ip -Port $port -WarningAction SilentlyContinue
        if ($result.TcpTestSucceeded) {
            $message = "Port $port is open on $ip."
            Write-Host $message
            Add-Content -Path $logFile -Value $message
        } else {
            $message = "Port $port is closed on $ip."
            Write-Host $message
            Add-Content -Path $logFile -Value $message
        }
    }
}

# Loop through each IP in the range
for ($i = $startIP; $i -le $endIP; $i++) {
    $ip = $baseIP + $i

    # Test connectivity using Test-NetConnection (ICMP ping)
    $ping = Test-NetConnection -ComputerName $ip -WarningAction SilentlyContinue

    if ($ping.PingSucceeded) {
        $message = "$ip is online."
        Write-Host $message
        Add-Content -Path $logFile -Value $message

        # Scan all ports on the online host sequentially (no threads)
        Test-Ports -ip $ip -ports $commonPorts -logFile $logFile
    } else {
        $message = "$ip is offline."
        Write-Host $message
        Add-Content -Path $logFile -Value $message
    }
}
 
