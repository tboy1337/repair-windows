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

echo Fixing MBR...
call bootrec /fixmbr >nul 2>&1
if %errorlevel% neq 0 (
    echo Failed to fix MBR.
)

echo Fixing BOOT...
call bootrec /fixboot >nul 2>&1
if %errorlevel% neq 0 (
    echo Failed to fix BOOT.
)

echo Rebuilding BCD...
call bootrec /rebuildbcd >nul 2>&1
if %errorlevel% neq 0 (
    echo Failed to rebuild BCD.
    echo Trying again.
    call bcdedit /export "%SystemDrive%\BCDBackup" >nul 2>&1
    call cd /d "%SystemDrive%\boot" >nul 2>&1
    call attrib bcd -s -h -r >nul 2>&1
    call ren "%SystemDrive%\boot\bcd" "bcd.old" >nul 2>&1
    call bootrec /rebuildbcd >nul 2>&1
)

echo Scanning OS...
call bootrec /scanos >nul 2>&1
if %errorlevel% neq 0 (
    echo Failed to Scan OS.
    echo Trying again.
    call ren "%SystemDrive%\bootmgr" "bootmgrbackup" >nul 2>&1
    call bootrec /RebuildBcd >nul 2>&1
    call bootrec /FixBoot >nul 2>&1
    call bootrec /scanos >nul 2>&1
)

timeout /t 5 /nobreak

exit /b 0