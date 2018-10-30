@echo off

set DIR=%~dp0
set BUILD_DIR=%cd%
set /P VERSION=<"%DIR%\harfbuzz.version"
set /P FLAGS=<"%DIR%\harfbuzz.flags"
set NAME=harfbuzz-%VERSION%

echo https://gigenet.dl.sourceforge.net/project/harfbuzz/harfbuzz2/%NAME%.tar.bz2
echo %NAME%.tar.bz2
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://www.freedesktop.org/software/harfbuzz/release/%NAME%.tar.bz2', '%NAME%.tar.bz2')"
7z e "%NAME%.tar.bz2"
7z x "%NAME%.tar"
cd "%NAME%"
call "%DIR%\%PLATFORM%-compile.bat" %*
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%

cd %BUILD_DIR%
