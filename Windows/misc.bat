@echo off

sc config WinDefend start= auto
net start WinDefend

echo Enabling Windows Firewall...
netsh advfirewall set allprofiles state on

echo Enabling CTRL+ALT+DEL...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\utilman.exe" /v Debugger /t REG_SZ /d "userinit.exe" /f

echo Warning users about bad certificates...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v WarnOnBadCertRecving /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v WarnOnBadCertSending /t REG_DWORD /d 1 /f

echo Enabling Do-Not-Track...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v DoNotTrack /t REG_DWORD /d 1 /f

echo Showing hidden files...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Hidden /t REG_DWORD /d 1 /f

echo Restricting USB storage devices...
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\USBSTOR" /v Start /t REG_DWORD /d 4 /f

echo Enabling User Account Control (UAC)...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 1 /f

echo Enabling Windows SmartScreen...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v SmartScreenEnabled /t REG_SZ /d RequireAdmin /f

echo Enabling Windows Defender Real-Time Protection...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 0 /f

echo Disabling autorun for CD/DVD drives...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoDriveTypeAutoRun /t REG_DWORD /d 4 /f

echo Disabling displaying last username on login...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v dontdisplaylastusername /t REG_DWORD /d 1 /f

echo Disabling AutoPlay for all drives...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoDriveTypeAutoRun /t REG_DWORD /d 255 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoDriveTypeAutoRun /t REG_DWORD /d 255 /f

echo Enabling Account lockout policy...
net accounts /lockoutthreshold:5 /lockoutduration:30 /lockoutwindow:30

echo Disabling Require CTRL+ALT+DEL
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableCAD /t REG_DWORD /d 1 /f

echo Restricting Powershell script execution
reg add "HKLM\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell" /v "ExecutionPolicy" /t REG_SZ /d "Restricted" /f

echo Configuring Event Log Size and Retention Settings
wevtutil sl Security /ms:65536 /rt:true

echo Disabling Powershell 2.0...
dism /online /disable-feature /featurename:MicrosoftWindowsPowerShellV2

echo Enabling auto-update in Registry
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d 3 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "ScheduledInstallDay" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "ScheduledInstallTime" /t REG_DWORD /d 3 /f

echo Securing screensaver
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v ScreenSaverIsSecure /t REG_SZ /d 1 /f

echo Will there be shared folders? (y/n)
set /p sharedFolders=
if /i "%sharedFolders%"=="n" (
    echo Disabling network discovery
    netsh advfirewall firewall set rule group="Network Discovery" new enable=no

    echo Disabling file and printer sharing
    netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=no

    echo Disabling public folder sharing
    netsh advfirewall firewall set rule group="Public" new enable=no

    echo Enabling password-protected sharing
    reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v RestrictNullSessAccess /t REG_DWORD /d 1 /f

    echo Stop and disable Server service
    net stop Server
    sc config LanmanServer start= disabled
)

echo Enable auditing? (y/n)
set /p enableAuditing=

if /i "%enableAuditing%"=="y" (
    echo Enabling all local audit policies...
    auditpol /set /category:"Account Logon" /success:enable /failure:enable
    auditpol /set /category:"Account Management" /success:enable /failure:enable
    auditpol /set /category:"Detailed Tracking" /success:enable /failure:enable
    auditpol /set /category:"DS Access" /success:enable /failure:enable
    auditpol /set /category:"Logon/Logoff" /success:enable /failure:enable
    auditpol /set /category:"Object Access" /success:enable /failure:enable
    auditpol /set /category:"Policy Change" /success:enable /failure:enable
    auditpol /set /category:"Privilege Use" /success:enable /failure:enable
    auditpol /set /category:"System" /success:enable /failure:enable
) else (
    echo Disabling all local audit policies...
    auditpol /set /category:"Account Logon" /success:disable /failure:disable
    auditpol /set /category:"Account Management" /success:disable /failure:disable
    auditpol /set /category:"Detailed Tracking" /success:disable /failure:disable
    auditpol /set /category:"DS Access" /success:disable /failure:disable
    auditpol /set /category:"Logon/Logoff" /success:disable /failure:disable
    auditpol /set /category:"Object Access" /success:disable /failure:disable
    auditpol /set /category:"Policy Change" /success:disable /failure:disable
    auditpol /set /category:"Privilege Use" /success:disable /failure:disable
    auditpol /set /category:"System" /success:disable /failure:disable
)

echo Do you want to disable Remote Assistance? (y/n)
set /p disableRA=

if /i "%disableRA%"=="y" (
    reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v fAllowToGetHelp /t REG_DWORD /d 0 /f
    echo Remote Assistance has been disabled.
)

echo Do you want to disable Remote Desktop? (y/n)
set /p disableRD=

if /i "%disableRD%"=="y" (
    reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 1 /f
    echo Remote Desktop has been disabled.
)
