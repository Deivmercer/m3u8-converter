@REM m3u8 converter
@REM Usage: "m3u8 converter.bat"
@REM m3u8 files must be located in .\m3u8
@REM Author: Davide Costantini

@echo off

if not exist "%~dp0m3u8\" (
    echo Subfolder m3u8 doesn't exists.
    goto :end
)

set /p vlc_path="Insert vlc.exe path: "
if "%vlc_path:~-8% equ "vlc.exe" set vlc_path=%vlc_path:~0,-8%"

if not exist "%~dp0mp4\" mkdir "%~dp0mp4\"

if not exist "%~dp0\converted\" mkdir "%~dp0\converted\"

for /r ".\m3u8" %%f in (*.m3u8) do (
    echo Converting %%f
    echo %~dp0mp4\%%~nf.mp4
    if exist "%~dp0mp4\%%~nf.mp4" (
        set /p choice="File with name "%%~nf.mp4" already exists. Would you like to replace it? [y/n] "
        if "%choice%" equ "y" (
            del "%~dp0mp4\%%~nf.mp4"
        )
    )
    start /d %vlc_path% /w vlc.exe "%%f" -I dummy --sout="#transcode{vcodec=h264,acodec=mpga,ab=128,channels=2,samplerate=44100,scodec=none,deinterlace}:std{access=file{no-overwrite},mux=mp4,dst='%~dp0mp4\%%~nf.mp4'}" vlc://quit
	move "%%f" "%~dp0\converted\"
)

:end
echo Ending script.