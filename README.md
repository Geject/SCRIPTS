# Bypassing Windows Firewall using Batch and PowerShell
This repository contains a script for bypass_WINDOWS_FIREWALL.bat which can be used to disable Windows Firewall on a target machine.
## How it works
The script searches for PowerShell.exe in the system's PATH, creates a temporary PowerShell script in %TEMP% with executable rights, and grants system rights to it. Then, it launches PowerShell to execute the temporary script. The script downloads an ignored URL from Google to bypass PowerShell's execution policy and disable the Windows Firewall via PowerShell. After the script execution, it cleans up by deleting the temporary PowerShell script.
### Usage
Download the bypass_WINDOWS_FIREWALL.bat file from this repository and save it to a trusted location
Run the batch script with administrative privileges
#### Note: This script should be used for educational purposes only and not for any malicious or unauthorized activities. Disabling the firewall on a system can leave it vulnerable to various types of attacks.
#### Requirements
Administrative privileges
Access to a target machine
powershell.exe must be present in the system's PATH
