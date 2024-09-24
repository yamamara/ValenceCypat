@echo off
echo Deleting banned files...

:: Prompt the user to choose the deletion mode
echo Select the deletion mode:
echo 1. Automatic Deletion
echo 2. Manual Deletion

set /p mode="Enter the mode (1 or 2): "

:: Set the mode (1 for Automatic, 2 for Manual)
if %mode% == 1 (
    set deleteAll=1
) else (
    set deleteAll=0
)

cd /d C:\

:: Automatic deletion of files with specified extensions
if %deleteAll% == 1 (
    echo Deleting files automatically...
    for %%x in (mp3 mov mp4 avi mpg mpeg flac m4a flv ogg gif png jpg jpeg) do (
        del /s /q /f *%%x >nul
        echo Deleted all files with the extension '%%x'.
    )
    echo Automatic deletion is complete.
    ) else (
        echo Manual deletion mode...

        :: List of file extensions to delete
        set "fileExtensions=mp3 mov mp4 avi mpg mpeg flac m4a flv ogg gif png jpg jpeg"

        :: Prompt to delete each individual file with specified extensions
        for %%x in (%fileExtensions%) do (
            for /r %%f in (*%%x) do (
                set /p deleteFile="Delete file '%%f'? (Y/N): "
                if /i "%deleteFile%"=="Y" (
                    del /q /f "%%f"
                    echo Deleted '%%f'.
                )
            )
        )

        :: Display a message to inform you that the manual deletion is complete
        echo Manual deletion is complete.
    )
