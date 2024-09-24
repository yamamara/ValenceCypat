@echo off

color 02
title Team1CyPat Windows Script

set mainDir=C:\Users\%USERNAME%\Downloads\Team1CyPat-main\Team1CyPat-main\Windows

NET SESSION >NUL 2>NUL
if %errorlevel% neq 0 (
    echo Script requires administrative privileges. Please run as an administrator.
    timeout /t 9999
)

for %%f in (users.bat services.bat delbannedfiles.bat misc.bat) do (
    echo %%f
    cd %mainDir%
    call %%f
    cls
)

echo Changing Powershell allowed language to ConstainedLanguage...
setx __PSLockDownPolicy 4 /m
gpupdate /force

echo Now running virus scan, do NOT close the terminal.
echo Make sure to check NonDefaultSettings.txt

echo Running Windows Defender Quick Scan...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 1

echo Running Windows Defender Full Scan...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" /Scan /ScanType 2
