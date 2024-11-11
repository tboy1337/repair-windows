@echo off
setlocal enabledelayedexpansion

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrator privileges.
    echo Please right-click and select "Run as administrator".
    timeout /t 5 /nobreak
    exit /b 2
)

cd /d "%SystemDrive%" >nul 2>&1
if %errorlevel% neq 0 (
    echo Failed to change to %SystemDrive% drive.
)

echo Checking %SystemDrive% file system...
call chkdsk "%SystemDrive%" >nul 2>&1
if %errorlevel% neq 0 (
    echo Issues found with %SystemDrive% file system.
    echo y | call chkdsk "%SystemDrive%" /R /X >nul 2>&1
    echo Restarting system to complete repairs.
    timeout /t 30 /nobreak
    call shutdown /r /f /t 0 >nul 2>&1
    exit /b 1
)

echo Found no issues with %SystemDrive% file system.

timeout /t 5 /nobreak

exit /b 0
