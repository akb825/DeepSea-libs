@echo off

set DIR=%~dp0
set BUILD_DIR=%cd%
set /P VERSION=<"%DIR%\freetype.version"
set /P FLAGS=<"%DIR%\freetype.flags"
set NAME=freetype-%VERSION%

powershell -Command "(New-Object Net.WebClient).DownloadFile('https://gigenet.dl.sourceforge.net/project/freetype/freetype2/%VERSION%/%NAME%.tar.bz2', '%NAME%.tar.bz2')"
7z e "%NAME%.tar.bz2"
7z x "%NAME%.tar"
cd "%NAME%"
call "%DIR%\%PLATFORM%-compile.bat" -DUNIX=ON %*
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%

cd %BUILD_DIR%
