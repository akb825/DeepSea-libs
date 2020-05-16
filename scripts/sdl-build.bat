@echo off

set DIR=%~dp0
set BUILD_DIR=%cd%
set /P VERSION=<"%DIR%\sdl.version"
set /P FLAGS=<"%DIR%\sdl.flags"
set NAME=SDL2-%VERSION%

powershell -Command "(New-Object Net.WebClient).DownloadFile('http://libsdl.org/release/%NAME%.zip', '%NAME%.zip')"
7z x "%NAME%.zip"
patch -p1 -d "%NAME%" -i "%DIR%/sdl-win-fix.patch"
cd "%NAME%"
call "%DIR%\%PLATFORM%-compile.bat" -DSDL_SHARED=OFF %FLAGS% %*
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%

cd %BUILD_DIR%
