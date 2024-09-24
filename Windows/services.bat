@echo off

setlocal enabledelayedexpansion
echo Disabling Windows services...
echo Please wait...

:: Prompt the user to choose the mode
echo.
echo Select the mode for disabling services:
echo 1. Automatically disable all services
echo 2. Manually choose which services to disable

set /p mode="Enter the mode (1 or 2): "

set services=Telephony TapiSrv Tlntsvr tlntsvr p2pimsvc simptcp fax msftpsvc iprip ftpsvc RasMan RasAuto seclogon MSFTPSVC W3SVC SMTPSVC Dfs TrkWks MSDTC DNS ERSVC NtFrs MSFtpsvc helpsvc HTTPFilter IISADMIN IsmServ WmdmPmSN Spooler RDSessMgr RPCLocator RsoPProv ShellHWDetection ScardSvr Sacsvr Uploadmgr VDS VSS WINS WinHttpAutoProxySvc SZCSVC CscService hidserv IPBusEnum PolicyAgent SCPolicySvc SharedAccess SSDPSRV Themes upnphost nfssvc nfsclnt MSSQLServerADHelper

:: Disable all services automatically or manually
if %mode% == 1 (
    for %%a in (!services!) do (
        echo Disabling %%a
        sc stop "%%a"
        sc config "%%a" start=disabled
    )
) else (
    for %%a in (!services!) do (
        choice /c yn /m "Do you wish to disable %%a? "
        if !ERRORLEVEL! equ 1 (
            echo Disabling %%a
            sc stop "%%a"
            sc config "%%a" start=disabled
        ) else (
            echo Skipping %%a
        )
    )
)

echo Starting and enabling required services...
sc start Appinfo
sc config Appinfo start= auto

set "services=Appinfo wuauserv bits"

for %%s in (%services%) do (
    sc config %%s start= auto
    net start %%s

    echo Enabling %%s
)


set "programs=7-Zip"

for %%p in (%programs%) do (
    echo Do you want to remove %%p? (Y/N)
    set /p "choice="

    if /i "!choice!"=="Y" (
        echo Removing %%p...
        rmdir /s /q "C:\Program Files\7-Zip"
        echo %%p removed.
    ) else (
        echo Skipping %%p removal.
    )

    echo.
)

set "games=Microsoft.GamingServices Microsoft.SolitaireCollection Microsoft.BingNews Microsoft.BingWeather Microsoft.Office.OneNote Microsoft.People Microsoft.Microsoft3DViewer Microsoft.ZuneMusic Microsoft.YourPhone Microsoft.Paint Microsoft.GamingApp Microsoft.MSPaint Microsoft.WindowsFeedbackHub Microsoft.XboxApp Microsoft.XboxGamingOverlay Microsoft.MicrosoftSolitaireCollection Microsoft.GetHelp"

for %%g in (%games%) do (
    echo Uninstalling %%g...
    PowerShell -Command "Get-AppxPackage -Name %%g | Remove-AppxPackage"
)

echo All Windows games have been uninstalled.