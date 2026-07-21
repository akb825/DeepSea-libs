@echo off

set DIR=%~dp0
set BUILD_DIR=%cd%
set /P VERSION=<"%DIR%\sdl.version"
set /P FLAGS=<"%DIR%\sdl.flags"
set NAME=SDL3-%VERSION%

powershell -Command "(New-Object Net.WebClient).DownloadFile('https://libsdl.org/release/%NAME%.zip', '%NAME%.zip')"
7z x "%NAME%.zip"
cd "%NAME%"
call "%DIR%\%PLATFORM%-compile.bat" %FLAGS% %*
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%

cd %BUILD_DIR%
