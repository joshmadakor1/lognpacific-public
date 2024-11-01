<#
.SYNOPSIS
    This script simulates a threat scenario by impersonating a user who installs a TOR
    browser and presumably uses it to do some darkweb shopping on a corporate workstation.
    The script below does the following:
———
    1. Downloads the TOR browser installer: https://www.torproject.org/download/
    2. Installs it silently.
    3. Opens the TOR browser.
    4. Creates a file containing a list of illicit items, simulating a user keeping track of purchases.
    5. Deletes the file containing illicit items after a period of time.
———

.NOTES
    Author          : Josh Madakor
    LinkedIn        : linkedin.com/in/joshmadakor/
    GitHub          : github.com/joshmadakor1
    Date Created    : 2024-09-09
    Last Modified   : 2024-09-09
    Version         : 1.0
    CVEs            : CVE-2014-3566
                      CVE-2021-23839
                      CVE-2011-3389
    Plugin IDs      : 20007
                      104743
                      157288
    STIG-ID         : WN10-CC-000105

.TESTED ON
    Date(s) Tested  : 2024-09-09
    Tested By       : Josh Madakor
    Systems Tested  : Windows Server 2019 Datacenter, Build 1809
                      Windows 10 Pro, Build 22H2
    PowerShell Ver. : 5.1.17763.6189

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\toggle-protocols.ps1 
#>

# Your code goes here
