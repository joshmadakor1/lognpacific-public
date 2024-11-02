# Use Case
**Detection of Unauthorized TOR Browser Installation and Use**

## Example Scenario:
Simulates a threat scenario by impersonating a user who installs a TOR browser and presumably uses it to do some dark web shopping on a corporate workstation.

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

## Detection Queries:
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


## Steps to Reproduce Above Logs:
1. Download the TOR browser installer: https://www.torproject.org/download/
2. Installs it silently with: tor-browser-windows-x86_64-portable-14.0.1.exe /S
3. Opens the TOR browser from the folder on the desktop
4. Connect to TOR and browse a few sites.
5. Create a folder on your desktop called shopping-list.txt and put a few fake (illicit) items in there
6. Delete the file.

---

## Supplemental:
- **What is Tor and Should You Use It? | Mashable Explains**: https://youtu.be/6czcc1gZ7Ak?si=NC2M0EzR8DSR53yt

---

## Created By:
- **Author Name**: Josh Madakor
- **Author Contact**: https://www.linkedin.com/in/joshmadakor/
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
| 1.0         | Initial draft                  | `September  6, 2024`  | `Josh Madakor`   