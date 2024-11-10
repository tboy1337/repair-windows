@echo off
setlocal enabledelayedexpansion

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrator privileges.
    echo Please right-click and select "Run as administrator".
    timeout /t 5 /nobreak
    exit /b 1
)

cd /d "%SystemDrive%" >nul 2>&1
if %errorlevel% neq 0 (
    echo Failed to change to %SystemDrive% drive.
)

echo Repairing System Volumes...
call powershell -Command "$ProgressPreference = 'SilentlyContinue'; Repair-Volume -FileSystemLabel "*" -OfflineScanAndFix >nul 2>&1

timeout /t 5 /nobreak

exit /b 0