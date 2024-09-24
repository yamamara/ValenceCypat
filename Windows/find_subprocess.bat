@echo off
set /p targetProcess="Enter the name of the target process: "

echo Searching for background processes that open '%targetProcess%'...

for /f "tokens=*" %%a in ('wmic process get caption,parentprocessid,processid ^| find " " ^| find /v "wmic"') do (
    set processInfo=%%a
    for /f "tokens=1,2,3 delims= " %%b in ("!processInfo!") do (
        set processName=%%b
        set parentProcessId=%%c
        set processId=%%d

        if /i "!processName!"=="%targetProcess%" (
            echo Process Name: !processName!
            echo   Process ID: !processId!
            echo   Parent Process ID: !parentProcessId!
            echo.
        )
    )
)

echo Search complete.
pause
