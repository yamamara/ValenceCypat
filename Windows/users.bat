@echo off

setlocal enabledelayedexpansion

:: Disable the Guest account
net user Guest /active:no >nul

:: Disable the Administrator account
net user Administrator /active:no >nul

:: Display a message to inform you that the accounts are disabled
echo Guest and Administrator accounts have been disabled.


set newPassword=NathanAreg@12345
set currentUser=%USERNAME%
set userList = (powershell "Get-LocalUser | Where-Object { $_.Name -ne 'Administrator' -and $_.Name -ne 'Guest' -and $_.Name -ne '%currentUser%' -and $_.Name -ne 'DefaultAccount' -and $_.Name -ne 'WDAGUtilityAccount' } | Select-Object -ExpandProperty Name")

:: Use PowerShell to get a list of user accounts (excluding system accounts)
for /f "delims=" %%a in (%userList%) do (
    echo Changing password for %%a to %newPassword%
    net user "%%a" %newPassword% >nul

    echo Enable password expiring for all users
    wmic useraccount where "Name='!username!'" set PasswordExpires=True

    echo Force password change on next login for all users
    net user "!username!" /logonpasswordchg:yes
    )
)

echo Passwords for all users except the current one have been changed to %newPassword%.


net accounts /minpwlen:14 /maxpwage:30 /minpwage:5 /uniquepw:24 >nul
secedit /configure /db %windir%\security\new.sdb /cfg %windir%\inf\defltbase.inf /areas SECURITYPOLICY /overwrite /quiet
echo Set strict password requirements

net accounts /lockoutthreshold:5 /lockoutduration:30 /lockoutwindow:30 >nul
echo Account lockout policy has been enabled.

echo Enter allowed usernames (space-seperated):
set /p allowedUsers=

for /f "delims=" %%a in (%userList%) do (
    set "username=%%a"
    
    rem Check if the user is in the allowed list
    echo !allowedUsers! | find "!username!" > nul
    if errorlevel 1 (
        if not "%%a" == "DefaultAccount" (
            echo Removing user: !username!
            net user !username! /delete
        )
    )
)

echo User removal completed.


echo Enter the list of allowed administrators (space-separated):
set /p allowedAdmins=

for /f "skip=7 tokens=*" %%a in ('net localgroup administrators ^| findstr /v /r "successfully."') do (
    set "adminUser=%%a"
    set userFound=0
    
    for %%b in (%allowedAdmins%) do (
        if /i "%%b"=="!adminUser!" (
            set userFound=1
        )
    )

    if "!userFound!" equ "0" (
        if not "%%a" == "DefaultAccount" (
            echo Removing administrator privileges from: !adminUser!
            net localgroup administrators "!adminUser!" /delete
        )
    )
)

for %%a in (%allowedAdmins%) do (
    if not "%%a" == "DefaultAccount" (
        echo Granting administrator privileges to: %%a
        net localgroup administrators %%a /add
    )
)

echo Administrator privileges granted to users in the allowed list.
