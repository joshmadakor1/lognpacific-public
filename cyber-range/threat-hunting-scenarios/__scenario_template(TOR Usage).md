# Use Case
**Detection of Unauthorized TOR Browser Installation and Use**

## Example Scenario:
Simulates a threat scenario by impersonating a user who installs a TOR browser and presumably uses it to do some dark web shopping on a corporate workstation. The script below does the following:
1. Downloads the TOR browser installer: https://www.torproject.org/download/
2. Installs it silently.
3. Opens the TOR browser.
4. Creates a file containing a list of illicit items, simulating a user keeping track of purchases.
5. Deletes the file containing illicit items after a period of time.
---

## Tables:
| **Parameter**       | **Description**                                                              |
|---------------------|------------------------------------------------------------------------------|
| **Name**| DeviceFileEvents|
| **Info**|https://learn.microsoft.com/en-us/defender-xdr/advanced-hunting-deviceinfo-table|
| **Purpose**| The DeviceInfo table in the advanced hunting schema contains information about devices in the organization, including OS version, active users, and computer name.|

| **Parameter**       | **Description**                                                              |
|---------------------|------------------------------------------------------------------------------|
| **Name**| DeviceProcessEvents|
| **Info**|https://learn.microsoft.com/en-us/defender-xdr/advanced-hunting-deviceinfo-table|
| **Purpose**| The DeviceProcessEvents table in the advanced hunting schema contains information about process creation and related events. Use this reference to construct queries that return information from this table.|

| **Parameter**       | **Description**                                                              |
|---------------------|------------------------------------------------------------------------------|
| **Name**| DeviceNetworkEvents|
| **Info**|https://learn.microsoft.com/en-us/defender-xdr/advanced-hunting-devicenetworkevents-table|
| **Purpose**| The DeviceNetworkEvents table in the advanced hunting schema contains information about network connections and related events. Use this reference to construct queries that return information from this table.|

---

## Detection Query:
```kql
// Installer name == tor-browser-windows-x86_64-portable-(version).exe
// Detect the installer being downloaded
DeviceFileEvents
| where FileName startswith "tor"

// TOR Browser being silently installed
// Take note of two spaces before the /S (I don't know why)
DeviceProcessEvents
| where ProcessCommandLine contains "tor-browser-windows-x86_64-portable-14.0.1.exe  /S"
| project Timestamp, DeviceName, ActionType, FileName, ProcessCommandLine

// TOR Browser or service was successfully installed and is present on the disk
DeviceFileEvents
| where FileName has_any ("tor.exe", "firefox.exe")
| project  Timestamp, DeviceName, RequestAccountName, ActionType, InitiatingProcessCommandLine

// TOR Browser or service was launched
DeviceProcessEvents
| where ProcessCommandLine has_any("tor.exe","firefox.exe")
| project  Timestamp, DeviceName, AccountName, ActionType, ProcessCommandLine

// TOR Browser or service is being used and is actively creating network connections
DeviceNetworkEvents
| where InitiatingProcessFileName in~ ("tor.exe", "meek-client.exe", "firefox.exe")
| project Timestamp, DeviceName, InitiatingProcessAccountName, InitiatingProcessFileName, RemoteIP, RemotePort

// User shopping list was created and, changed, or deleted
DeviceFileEvents
| where FileName contains "shopping-list.txt"
```

---

## Sample Output:

<img width="800" alt="image" src="https://github.com/user-attachments/assets/922e6629-6ec0-4e9e-a204-977e7a6cc1c2">

<img width="800" alt="image" src="https://github.com/user-attachments/assets/6ef273a3-51de-426a-8840-73dcd81db3f9">

<img width="800" alt="image" src="https://github.com/user-attachments/assets/725dcbf1-0f2c-46cc-9e48-f28a311f10bc">

<img width="800" alt="image" src="https://github.com/user-attachments/assets/04949b99-1383-4c48-8ba4-265fc6d21336">

<img width="800" alt="image" src="https://github.com/user-attachments/assets/ed8191a0-0cea-4867-8685-4a655c5bff4c">

<img width="800" alt="image" src="https://github.com/user-attachments/assets/75791401-9b1b-49d9-a8b8-019e2d4bd1c3">


## Steps to Reproduce:
1. Provision a virtual machine with a public IP address
2. Ensure the device is actively communicating or available on the internet. (Test ping, etc.)
3. Onboard the device to Microsoft Defender for Endpoint
4. Verify the relevant logs (e.g., network traffic logs, exposure alerts) are being collected in MDE.
5. Execute the KQL query in the MDE advanced hunting to confirm detection.

---

## Supplemental:
- **More on "Shared Services" in the context of PCI DSS**: [PCI DSS Scoping and Segmentation](https://www.pcisecuritystandards.org%2Fdocuments%2FGuidance-PCI-DSS-Scoping-and-Segmentation_v1.pdf)

---

## Created By:
- **Author Name**: Sijia Li
- **Author Contact**: https://www.linkedin.com/in/sijiasevon/
- **Date**: August 31, 2024

## Validated By:
- **Reviewer Name**: Josh Madakor
- **Reviewer Contact**: https://www.linkedin.com/in/joshmadakor/
- **Validation Date**: September 6, 2024

---

## Additional Notes:
- **None**

---

## Revision History:
| **Version** | **Changes**                   | **Date**         | **Modified By**   |
|-------------|-------------------------------|------------------|-------------------|
| 1.0         | Initial draft                  | `September  6, 2024`  | `Sijia Li`   
