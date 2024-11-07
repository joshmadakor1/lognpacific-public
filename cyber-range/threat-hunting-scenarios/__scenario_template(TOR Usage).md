# Scenario Construction Cheatsheet
**Detection of Unauthorized TOR Browser Installation and Use**

## Example Scenario:
Detect unauthorized use of TOR browsers within the corporate network, as TOR usage may indicate attempts to access the dark web, hide internet activity, or bypass network security controls. The exercise will aim to detect this behavior and analyze related security incidents.

---

## Steps the "Bad Actor" took Create Logs and IoCs:
1. Download the TOR browser installer: https://www.torproject.org/download/
2. Install it silently: ```tor-browser-windows-x86_64-portable-14.0.1.exe /S```
3. Opens the TOR browser from the folder on the desktop
4. Connect to TOR and browse a few sites.
   - Current Dread Forum: ```g66ol3eb5ujdckzqqfmjsbpdjufmjd5nsgdipvxmsh7rckzlhywlzlqd.onion```
   - Dark Markets Forum: ```g66ol3eb5ujdckzqqfmjsbpdjufmjd5nsgdipvxmsh7rckzlhywlzlqd.onion/d/DarkNetMarkets```
   - Current Elysium Market: ```elysiumyeudtha62s4oaowwm7ifmnunz3khs4sllhvinphfm4nirfcqd.onion```
6. Create a folder on your desktop called ```tor-shopping-list.txt`` and put a few fake (illicit) items in there
7. Delete the file.

---

## Tables:
| **Parameter**       | **Description**                                                              |
|---------------------|------------------------------------------------------------------------------|
| **Name**| DeviceFileEvents|
| **Info**|https://learn.microsoft.com/en-us/defender-xdr/advanced-hunting-deviceinfo-table|
| **Purpose**| Used for detecting TOR download and installation, as well as the shopping list creation and deletion. |

| **Parameter**       | **Description**                                                              |
|---------------------|------------------------------------------------------------------------------|
| **Name**| DeviceProcessEvents|
| **Info**|https://learn.microsoft.com/en-us/defender-xdr/advanced-hunting-deviceinfo-table|
| **Purpose**| Used to detect the silent installation of TOR as well as the TOR browser and service launching.|

| **Parameter**       | **Description**                                                              |
|---------------------|------------------------------------------------------------------------------|
| **Name**| DeviceNetworkEvents|
| **Info**|https://learn.microsoft.com/en-us/defender-xdr/advanced-hunting-devicenetworkevents-table|
| **Purpose**| Used to detect TOR network activity, specifically tor.exe and firefox.exe making connections over ports to be used by TOR (9001, 9030, 9040, 9050, 9051, 9150).|

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
| where InitiatingProcessFileName in~ ("tor.exe", "firefox.exe")
| where RemotePort in (9001, 9030, 9040, 9050, 9051, 9150)
| project Timestamp, DeviceName, InitiatingProcessAccountName, InitiatingProcessFileName, RemoteIP, RemotePort, RemoteUrl
| order by Timestamp desc

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

## Response Instructions
If TOR usage is confirmed on a specific endpoint, isolate the device from the network and notify the user’s manager.

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
