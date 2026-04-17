**Subject:** Vulnerability Remediation Commands & Scripts for Testing and Deployment

**Hi [Team],**

Based on our initial vulnerability scan and assessment, we have prepared remediation commands and scripts to help you tackle the initial remediation efforts. These can be integrated into your deployment platform (e.g., SCCM). Please test them before deploying to production.

All commands below should be run as **Administrator**.

---

### 1. Windows OS Updates (Re-enable Automatic Updates)

Run this in **Command Prompt (Admin)**:
```shell
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v ScheduledInstallDay /t REG_DWORD /d 0 /f; reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 0 /f; reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions /t REG_DWORD /d 4 /f
```

Then open **Settings > Windows Update** and install all pending updates until none remain.

Verify with:
```shell
reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
```

---

### 2. Guest Account Group Membership (Remove from Administrators & Disable)

Run these in **Command Prompt (Admin)** one at a time:
```shell
net localgroup Administrators Guest /delete
```
```shell
net user Guest /active:no
```

---

### 3. Third-Party Software Removal (Outdated Wireshark & WinPcap)

Run this **PowerShell script** as Administrator. You can download and execute it directly:
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/kenbananola/ken-remediation-scripts/main/wireshark-winpcap-force-remove.ps1" -OutFile "$env:TEMP\wireshark-remove.ps1"; PowerShell -ExecutionPolicy Bypass -File "$env:TEMP\wireshark-remove.ps1"
```

Or view/download the script manually here: [wireshark-winpcap-force-remove.ps1](https://github.com/kenbananola/ken-remediation-scripts/blob/main/wireshark-winpcap-force-remove.ps1)

---

### 4. SMB Signing (Re-enable)

Run this in **PowerShell (Admin)**:
```powershell
Set-SmbServerConfiguration -RequireSecuritySignature $true -EnableSecuritySignature $true -Force
```

Verify with:
```powershell
Get-SmbServerConfiguration | Select RequireSecuritySignature, EnableSecuritySignature
```

Both values should return **True**.

---

### 5. RDP Network Level Authentication (Re-enable NLA)

Run this in **PowerShell (Admin)**:
```powershell
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "UserAuthentication" -Value 1 -Force
```

Verify with:
```powershell
Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "UserAuthentication"
```

`UserAuthentication` should return **1**.

---

### 6. Weak LAN Manager Authentication Level (Restore to Secure Default)

Run this in **Command Prompt (Admin)**:
```shell
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v LmCompatibilityLevel /t REG_DWORD /d 5 /f
```

Verify with:
```shell
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v LmCompatibilityLevel
```

It should return **0x5**.

---

Let me know if you have any questions or need any adjustments!

Best regards,
**[Your Name], Security Analyst**<br/>
**Governance, Risk, and Compliance**
